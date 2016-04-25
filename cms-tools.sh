#!/bin/bash
#cms-tools.sh v1.0 -- by Roberto Chaud
#


########################## JOOMLA ########################################
function joomla_site() {
####Check if there is a Joomla config file.
if [ ! -f configuration.php ];
then
echo -e "\n\n======THERE IS NO JOOMLA CONFIG FILE. CHECK THIS IS THE CORRECT PATH OR configuration.php(REQUIRED) EXIST=====\n\n" && exit 0
fi

###GET MySQL
jmdbUser=$(grep "[$]user =" configuration.php | cut -d"=" -f 2 | cut -d"'" -f 2)
jmdbName=$(grep "[$]db =" configuration.php | cut -d"=" -f 2 | cut -d"'" -f 2)
jmdbPass=$(grep "[$]password =" configuration.php | cut -d"=" -f 2 | cut -d"'" -f 2)
jmdbPref=$(grep "[$]dbprefix =" configuration.php | cut -d"=" -f 2 | cut -d"'" -f 2)

###Variables
jmpath=$(pwd)
#Joomla Version
jmVersion=$(mysql -e "SELECT version_id FROM "$jmdbPref"schemas WHERE extension_id = '700';" -u $jmdbUser -p$jmdbPass $jmdbName -BN)
#Site name
jmsiteName=$(grep "[$]sitename =" configuration.php | cut -d"=" -f 2 | cut -d"'" -f 2)
#Site Description
jmsiteDesc=$(grep "[$]MetaDesc =" configuration.php | cut -d"=" -f 2 | cut -d"'" -f 2)
#Maintenance
jmmaint=$(
if grep -q "[$]offline = '0'" configuration.php ;
        then echo "No"
        else echo "Enabled"
fi
)
#Compression
jmgZip=$(
if grep -q "[$]gzip = '0'" configuration.php ;
        then echo "No"
        else echo "Enabled"
fi
)
#Cache Time
jmcacheTime=$(grep "[$]cachetime =" configuration.php | cut -d"'" -f 2)
#Caching
jmcaching=$(
if grep -q "[$]caching = '0'" configuration.php ;
        then echo "No"
        else echo "Enabled"
             echo "Cache Time  : $jmcacheTime min"
fi
)
#SEF, Rewrite, Suffix, Captcha
jmsef=$(
if grep -q "[$]sef = '0'" configuration.php ;
        then echo "No"
        else echo "Yes"
fi
)
jmreWrite=$(
if grep -q "rewrite = '0'" configuration.php ;
        then echo "No"
        else echo "Yes"
fi
)
jmsuffix=$(
if grep -q "[$]sef_suffix = '0'" configuration.php ;
        then echo "No"
        else echo "Yes"
fi
)
jmreCaptcha=$(
if grep -q "[$]captcha = '0'" configuration.php ;
        then echo "No"
        else echo "Yes"
fi
)

##Get Enabled and Disabled Non Default Plugins
jmplugins=$(mysql -t -e "SELECT name AS Plugins,folder AS Location , CASE WHEN enabled = 0 THEN 'Disabled' ELSE 'Enabled' END AS Status FROM "$jmdbPref"extensions WHERE type = 'plugin' AND name NOT LIKE 'plg_%' ORDER BY enabled;" -u $jmdbUser -p$jmdbPass $jmdbName)
##Get Admin and Front End Templates
jmtemplates=$(mysql -t -e "SELECT name AS Templates, CASE WHEN re.home = '1' THEN 'Default' ELSE ' ' END AS Status, CASE WHEN us.client_id = '1' THEN 'Admin' ELSE 'Site' END AS Location  FROM "$jmdbPref"extensions AS us, "$jmdbPref"template_styles AS re WHERE us.name = re.template ORDER BY us.client_id;" -u $jmdbUser -p$jmdbPass $jmdbName)

###Command Output
echo -e "\n==========[ Joomla Overview ]=========="
#Site Details section
echo -e "Path    : $jmpath"
echo -e "Version : $jmVersion"

printf "\n"
echo -e "Site Name : $jmsiteName"
echo -e "Site Desc : $jmsiteDesc"

printf "\n"
echo -e "Database    : $jmdbName"
echo -e "Prefix      : $jmdbPref"
echo -e "Maint Mode  : $jmmaint"
echo -e "Compression : $jmgZip"
echo -e "Caching     : $jmcaching"

#SEF, Rewrite, Suffix, Captcha
printf "\n"
echo -e "SEF URLs   : $jmsef"
echo -e "ReWrite    : $jmreWrite"
echo -e "SEF Suffix : $jmsuffix"
echo -e "CAPTCHA    : $jmreCaptcha"

#Templates, Plugins
printf "\n"
printf "$jmtemplates\n"
printf "$jmplugins"
echo -e "\n"

}
############################## JOOMLA END #####################################

############################## WORDPRESS ######################################
function wordpress_site() {
####Check if there is a WordPress config file.
if [ ! -f wp-config.php ];
then
echo -e "\n\n======THERE IS NO WORDPRESS CONFIG FILE. CHECK THIS IS THE CORRECT PATH OR wp-config.php(REQUIRED) EXIST=====\n\n" && exit 0
fi

###GET MySQL
wpdbUser=$(grep "DB_USER" wp-config.php | cut -d"'" -f 4 | cut -d"'" -f 2)
wpdbName=$(grep "DB_NAME" wp-config.php | cut -d"'" -f 4 | cut -d"'" -f 2)
wpdbPass=$(grep "DB_PASSWORD" wp-config.php | cut -d"'" -f 4 | cut -d"'" -f 2)
wpdbPref=$(grep "[$]table_prefix" wp-config.php | cut -d"=" -f 2 | cut -d"'" -f 2)

###Variables
wppath=$(pwd)
wpVersion=$(
if [ -f $wppath/wp-includes/version.php ];
then
wpVersionID=$(grep "[$]wp_version =" $wppath/wp-includes/version.php | cut -d"'" -f 2)
echo "$wpVersionID"
else
echo -e "Cannot Determine" && exit 0
fi
)

###Command Output
echo -e "\n==========[ Joomla Overview ]=========="
#Site Details section
echo -e "Path    : $wppath"
echo -e "Version : $wpVersion"

printf "\n"
echo -e "Database    : $wpdbName"
echo -e "Prefix      : $wpdbPref"

}
############################## WORDPRESS END ##################################


######################### USAGE DETAILS ###################################
usage() {
        cat <<EOF
$O cms-tools v1.0 by Roberto Chaud | http://robertochaud.com

$O Command Options --
        -h | --help        Show this menu.
        -j | --joomla      Joomla website deatails.
        -w | --wordpress   WordPress website details.
        -d | --drupal      Drupal website details.
EOF
}
########################### USAGE DETAILS END ############################


############################## ACTUAL COMMAND #################################
options=$(getopt -o hjwd --long help,joomla,wordpress,drupal:: -- "$@")
[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    echo "Try using --help for more details."
    exit 1
}
eval set -- "$options"
while true; do
    case "$1" in
    -h | --help )
        usage
        ;;
    -j | --joomla)
        joomla_site
        ;;
    -w | --wordpress)
        wordpress_site
        ;;
    -d | --drupal)
        echo Drupal
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

############################### ACTUAL COMMAND END #############################
