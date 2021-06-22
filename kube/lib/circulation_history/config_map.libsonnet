{
    local config = $._config.circulation_history,
    configMapData+::{
       RAILS_ENV: 'production',
       CIRC_REPORT_PATH: "/shared/University of Michigan 01UMICH_INST/Reports/apps/circ-history/circ-history",
       PATRON_REPORT_PATH: "/shared/University of Michigan 01UMICH_INST/Reports/apps/circ-history/non-expired-patrons",
       ALMA_API_HOST: "https://api-na.hosted.exlibrisgroup.com",
       DATABASE_HOST: config.db.name,
    }
}
