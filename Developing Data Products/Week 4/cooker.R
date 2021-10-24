library(sf)
library(rjson)
library(dplyr)
library(stringr)
shape_file_name = file.path("Census_Tracts_2010","c16590ca-5adf-4332-aaec-9323b2fa7e7d2020328-1-1jurugw.pr6w.shp")
shape_file = st_read(shape_file_name)
#----------------------------------------------------------------------------------------------
sex_by_age_data_name = file.path("acs2019_5yr_B01001_14000US42101038200","acs2019_5yr_B01001_14000US42101038200.csv")
sex_by_age_meta_name = file.path("acs2019_5yr_B01001_14000US42101038200","metadata.json")
sex_by_age_data = read.csv(sex_by_age_data_name)
sex_by_age_data = sex_by_age_data[,-grep("Error",colnames(sex_by_age_data))]
sex_by_age_meta = fromJSON(file=sex_by_age_meta_name)

prefix <- ""
sex_by_age_split = list()
current_split <- ""
for (key in names(sex_by_age_meta$tables$B01001$columns)){
  value <- sex_by_age_meta$tables$B01001$columns[[key]]
  #print(value)
  if (value$indent == 0)
  {
    colnames(sex_by_age_data)[colnames(sex_by_age_data) == key] <- str_remove(value$name,":")
  }  
  else if (value$indent == 1)
  {
    prefix <- value$name
    current_split <- str_remove(value$name,":")
    colnames(sex_by_age_data)[colnames(sex_by_age_data) == key] <- current_split
    sex_by_age_split[[current_split]] <-sex_by_age_data %>% 
      mutate( GEOID10 = gsub(".*US","",geoid )) %>% select(GEOID10)
    
  } else {
    sex_by_age_split[[current_split]][,value$name] <- sex_by_age_data[,key]
    colnames(sex_by_age_data)[colnames(sex_by_age_data) == key] <-paste(prefix,value$name)
  }
}
sex_by_age_data <- sex_by_age_data %>% 
  mutate( GEOID10 = gsub(".*US","",geoid ),Age = Male/Total)


#----------------------------------------------------------------------------------------------
sex_by_education_data_name = file.path("acs2019_5yr_B15002_14000US42101038200","acs2019_5yr_B15002_14000US42101038200.csv")
sex_by_education_meta_name = file.path("acs2019_5yr_B15002_14000US42101038200","metadata.json")
sex_by_education_data = read.csv(sex_by_education_data_name)
sex_by_education_data = sex_by_education_data[,-grep("Error",colnames(sex_by_education_data))]
sex_by_education_meta = fromJSON(file=sex_by_education_meta_name)
prefix <- ""
sex_by_education_split = list()
current_split <- ""
for (key in names(sex_by_education_meta$tables$B15002$columns)){
  value <- sex_by_education_meta$tables$B15002$columns[[key]]
  #print(value)
  if (value$indent == 0)
  {
    colnames(sex_by_education_data)[colnames(sex_by_education_data) == key] <- str_remove(value$name,":")
  }  
  else if (value$indent == 1)
  {
    prefix <- value$name
    current_split <- str_remove(value$name,":")
    colnames(sex_by_education_data)[colnames(sex_by_education_data) == key] <- current_split
    sex_by_education_split[[current_split]] <-sex_by_education_data %>% 
      mutate( GEOID10 = gsub(".*US","",geoid )) %>% select(GEOID10)
    
  } else {
    sex_by_education_split[[current_split]][,value$name] <- sex_by_education_data[,key]
    colnames(sex_by_education_data)[colnames(sex_by_education_data) == key] <-paste(prefix,value$name)
  }
}
sex_by_education_data <- sex_by_education_data %>% 
  mutate( GEOID10 = gsub(".*US","",geoid ),Education = Male/Total)
#----------------------------------------------------------------------------------------------
shape_data_merged <- Reduce(function(x,y) merge(x,y,by="GEOID10"),list(shape_file,
                                                                       sex_by_age_data %>% select(GEOID10,Age),
                                                                       sex_by_education_data %>% select(GEOID10,Education)))
shape_data_merged <- shape_data_merged %>% filter(!is.na(Age))
#----------------------------------------------------------------------------------------------

out_data  <- list("shape_file" = shape_data_merged,
                  "Age" = sex_by_age_split,
                  "Education" = sex_by_education_split)
output_name = file.path("census_viewer","data.rds")
saveRDS(out_data,file=output_name)
in_data <- readRDS(output_name)
print(in_data["Age"]$Male)