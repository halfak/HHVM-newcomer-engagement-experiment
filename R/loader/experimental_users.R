source("env.R")
source("util.R")

load_experimental_users = tsv_loader(
    paste(DATA_DIR, "experimental_user.tsv", sep="/"),
    "EXPERIMENTAL_USERS",
    function(dt){
        dt$bucket = factor(ifor(dt$user_id %% 2 == 0, "hhvm", "php5"))
        
        dt$user_type = factor(ifor(dt$new_user, "new", "attached"))
        dt$ui_type = factor(ifor(dt$display_mobile, "mobile", "desktop"))
        
        dt
    }
)
