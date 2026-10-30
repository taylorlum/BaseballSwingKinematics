# load the necessary libraries
library(readr)
library(signal)
library(dplyr)

# read in each data set
batter1 <- read_csv("data/batter1.csv")
batter2 <- read_csv("data/batter2.csv")
batter3 <- read_csv("data/batter3.csv")
batter4 <- read_csv("data/batter4.csv")
batter5 <- read_csv("data/batter5.csv")

# find which columns are not common across all batters
cols <- list(batter1 = colnames(batter1),
             batter2 = colnames(batter2),
             batter3 = colnames(batter3),
             batter4 = colnames(batter4),
             batter5 = colnames(batter5))

common <- Reduce(intersect, cols) # columns in all five
all_cols <- Reduce(union, cols) # columns in any of them

setdiff(all_cols, common) 
# contact_x, exit_speed_mph, horizontal_launch_angle_x, vertical_launch_angle_x, hand_trigger_x


# check for duplication
sum(duplicated(batter1))
sum(duplicated(batter2))
sum(duplicated(batter3))
sum(duplicated(batter4))
sum(duplicated(batter5))

# ensure time is increasing
!is.unsorted(batter1$time_x)
!is.unsorted(batter2$time_x)
!is.unsorted(batter3$time_x)
!is.unsorted(batter4$time_x)
!is.unsorted(batter5$time_x)

# function to help smooth high frequency noise from the movement data
butterworth_smooth <- function(data) {
  
  sampling_rate <- 300  #Hz, based on frame capture every 0.00333 seconds
  cutoff_freq   <- 13 # number chosen based on research
  nyquist       <- sampling_rate / 2
  normalized_cf <- cutoff_freq / nyquist
  
  # 4th-order low-pass Butterworth filter
  bf <- butter(n = 2, W = normalized_cf, type = "low")
  
  data <- data[-c(1, nrow(data)), ] %>%
    mutate(
      pelvis_smooth = filtfilt(bf, pelvis_angular_velocity_z),
      torso_smooth = filtfilt(bf, torso_angular_velocity_z),
      lead_hand_smooth = filtfilt(bf, lead_hand_global_angular_velocity_z))
}

# apply function to data
batter1_smooth <- butterworth_smooth(batter1)
batter2_smooth <- butterworth_smooth(batter2)
batter3_smooth <- butterworth_smooth(batter3)
batter4_smooth <- butterworth_smooth(batter4)
batter5_smooth <- butterworth_smooth(batter5)

# validate the frame capture frequency
summary(diff(batter1_smooth$time_x))
summary(diff(batter2_smooth$time_x))
summary(diff(batter3_smooth$time_x))
summary(diff(batter4_smooth$time_x))
summary(diff(batter5_smooth$time_x))
