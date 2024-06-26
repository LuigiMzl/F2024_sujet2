map_leaflet_airport <- function(df, airports_location, months, years){
  
  palette <- c("green", "blue", "red")
  
  trafic_date <- df %>%
    mutate(
      date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
    ) %>%
    filter(mois == months, an == years)
  
  trafic_aeroports <- airports_location %>%
    select(Code.OACI, Nom, geometry) %>% 
    inner_join(trafic_date, by = c("Code.OACI" = "apt"))
  
  
  trafic_aeroports <- trafic_aeroports %>%
    mutate(
      trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr,
      volume = ntile(trafic, 3)
    ) %>%
    mutate(
      color = palette[volume]
    )  
  
  icons <- awesomeIcons(
    icon = 'plane',
    iconColor = 'black',
    library = 'fa',
    markerColor = trafic_aeroports$color
  )
  
  carte_interactive <- leaflet(trafic_aeroports) %>% addTiles() %>%
    addAwesomeMarkers(
      icon=icons[],
      label=~paste0(Nom, "", " (",Code.OACI, ") : ", trafic, " voyageurs")
    )
  
  return(carte_interactive)
}
