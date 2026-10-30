# function to get performance metrics from each swing
swing_summary <- function(data) {
  
  # missed the ball: fill in contact time as when approach data ends 
  if (sum(is.na(data$ball_hit_x)) == nrow(data)) {
    contact_row <- data %>%
      dplyr::filter(!is.na(vertical_approach_angle_x)) %>%
      slice_tail(n = 1)
    
    contact_time <- contact_row$time_x
  } 
  # hit the ball: contact time is the last row before hit ball measurements begin
  else {
    contact_row <- data %>%
      mutate(row_id = row_number()) %>%
      dplyr::filter(is.na(ball_hit_x) & dplyr::lead(!is.na(ball_hit_x), default = FALSE)) %>%
      slice(1)
    
    contact_time <- contact_row$time_x
  }
  
  # peak angular velocities just before contact
  pre_contact_window <- data %>%
    dplyr::filter(time_x >= (contact_time - 0.2) & time_x <= contact_time) # dplyr:: notation to override stats::filter()
  
  # fluctuates more, usually peaks just before contact
  pre_contact_hands <- data %>%
    dplyr::filter(time_x >= (contact_time - 0.05) & time_x <= contact_time)
  
  pelvis_peak = pre_contact_window %>% slice_max(pelvis_smooth, n = 1)
  torso_peak = pre_contact_window %>% slice_max(torso_smooth, n = 1)
  lead_hand_peak = pre_contact_hands %>% slice_max(abs(lead_hand_smooth), n = 1)
  
  # timing lags between chain parts (ms)
  pelvis_torso_lag <- (torso_peak$time_x - pelvis_peak$time_x) * 1000
  torso_hand_lag <- (lead_hand_peak$time_x - torso_peak$time_x) * 1000
  
  # swing plane
  vertical_attack <- contact_row$vertical_attack_angle_x
  vertical_approach <- contact_row$vertical_approach_angle_x
  vertical_plane_delta <- vertical_attack - vertical_approach
  
  # output
  peak_bat_speed <- max(data$bat_speed_mph_x, na.rm = TRUE)
  
  # if they made contact with the ball
  if (sum(is.na(data$ball_hit_x)) != nrow(data)) {
    exit_speed <- data %>% 
      tidyr::drop_na(exit_speed_mph_x) %>% 
      slice(1) %>% 
      pull(exit_speed_mph_x)
  } 
  # missed the ball, no exit speed
  else {
    exit_speed <- NA
  }
  
  data.frame(
    Contact_Time = contact_time,
    Pelvis_Torso_Lag_ms = pelvis_torso_lag,
    Torso_Hand_Lag_ms = torso_hand_lag,
    Vertical_Attack = vertical_attack,
    Vertical_Plane_Delta = vertical_plane_delta,
    Peak_Bat_Speed_mph = peak_bat_speed,
    Exit_Speed_mph = exit_speed
  )
  
}

batter1_swing <- swing_summary(batter1_smooth)
batter2_swing <- swing_summary(batter2_smooth)
# skip batter3 because it is the same take as batter2
batter4_swing <- swing_summary(batter4_smooth)
batter5_swing <- swing_summary(batter5_smooth)

all_batters <- bind_rows("Batter 1" = batter1_swing, 
                         "Batter 2" = batter2_swing, 
                         "Batter 4" = batter4_swing, 
                         "Batter 5" = batter5_swing,
                         .id = "Batter")

write_csv(all_batters, "outputs/performance_summary.csv")


