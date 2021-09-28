srcURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
neiFile = "summarySCC_PM25.rds"
sccFile = "Source_Classification_Code.rds"

if(!file.exists(neiFile) || !file.exists(sccFile))
{
  print("Downloading Data")
  download.file(srcURL,'tmp.zip',method='curl')
  unzip("tmp.zip")
  unlink("tmp.zip")
} else {
  print("Data Already Downloaded")
}

if(!exists("NEIData"))
{
  print("Loading NEI Data")
  NEIData = readRDS(neiFile)
} else {
  print("NEI Data Already Loaded")  
  
}

if(!exists("SCCData"))
{
  print("Loading SCC Data")
  SCCData = readRDS(sccFile)
} else {
  print("SCC Data Already Loaded")  
  
}

