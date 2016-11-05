INIFILE_TMP="/tmp/waffles-test-ini.$$"

log.debug "tmp file is ${INIFILE_TMP}"

create_tmp_file() {
cat <<-"EOF" > "${INIFILE_TMP}"
opt=a global option
singleglobal
[section 1]
opt=a section 1 option
[section 2]
opt=a section 2 option
EOF
}
create_tmp_file

log.info "ini_file.get_option"
##############################

if [[ $(ini_file.get_option "${INIFILE_TMP}" "section 1" "opt") == "opt=a section 1 option" ]]; then
  log.info OK
else
  log.error FAIL
fi

if [[ $(ini_file.get_option "${INIFILE_TMP}" "section 2" "opt") == "opt=a section 2 option" ]]; then
  log.info OK
else
  log.error FAIL
fi

if [[ $(ini_file.get_option "${INIFILE_TMP}" "__none__" "opt") == "opt=a global option" ]]; then
  log.info OK
else
  log.error FAIL
fi

_return_code=0
x=$(ini_file.get_option "${INIFILE_TMP}" "__none__" "globalnotexist") || _return_code="$?"
if [[ "$_return_code" -eq 0 && -z "$x" ]]; then
  log.info OK
else
  log.error FAIL
fi
unset x

x=$(ini_file.get_option "${INIFILE_TMP}-not_exist" "__none__" "global") || _return_code="$?"
if [[ "$_return_code" -eq 1 && -z "$x" ]]; then
  log.info OK
else
  log.error FAIL
fi
unset x

log.info "ini_file.option_has_value"
####################################

x=$(ini_file.option_has_value "${INIFILE_TMP}" "section 1" "opt" "a section 1 option")
if [[ "$?" -eq 0 && -z "$x" ]]; then
  log.info OK
else
  log.error FAIL
fi
unset x

x=$(ini_file.option_has_value "${INIFILE_TMP}" "section 2" "opt" "a section 2 option")
if [[ "$?" -eq 0 && -z "$x" ]]; then
  log.info OK
else
  log.error FAIL
fi
unset x

x=$(ini_file.option_has_value "${INIFILE_TMP}" "__none__" "opt" "a global option")
if [[ "$?" -eq 0 && -z "$x" ]]; then
  log.info OK
else
  log.error FAIL
fi
unset x

x=$(ini_file.option_has_value "${INIFILE_TMP}" "__none__" "singleglobal" "__none__")
if [[ "$?" -eq 0 && -z "$x" ]]; then
  log.info OK
else
  log.error FAIL
fi
unset x

x=$(ini_file.option_has_value "${INIFILE_TMP}" "__none__" "global" "a global value")
if [[ "$?" -eq 1 && -z "$x" ]]; then
  log.info OK
else
  log.error FAIL
fi
unset x

log.info "ini_file.has_section"
###############################

if ini_file.has_section "${INIFILE_TMP}" "section 1"; then
  log.info OK
else
  log.error FAIL
fi

if ! ini_file.has_section "${INIFILE_TMP}" "section 3"; then
  log.info OK
else
  log.error FAIL
fi

log.info "ini_file.remove_section"
##################################

ini_file.remove_section "${INIFILE_TMP}" "section 1"
# md5sum "${INIFILE_TMP}"
# cat "${INIFILE_TMP}"
if [[ $(md5sum "${INIFILE_TMP}" | cut -d' ' -f1) == "fab7710592ad0507929240d15630ce8c" ]]; then
  log.info OK
else
  log.error FAIL
fi
create_tmp_file

log.info "ini_file.remove"
##########################

# md5sum "${INIFILE_TMP}"
ini_file.remove "${INIFILE_TMP}" "__none__" "singleglobal"
# cat "${INIFILE_TMP}"
if [[ $(md5sum "${INIFILE_TMP}" | cut -d' ' -f1) == "1f5774dcf9512c3516bded5dfee6cf82" ]]; then
  log.info OK
else
  log.error FAIL
fi

# md5sum "${INIFILE_TMP}"
ini_file.remove "${INIFILE_TMP}" "section 1" "opt"
# cat "${INIFILE_TMP}"
if [[ $(md5sum "${INIFILE_TMP}" | cut -d' ' -f1) == "ccf1bb6f2abaa91199d27338756b8119" ]]; then
  log.info OK
else
  log.error FAIL
fi
# md5sum "${INIFILE_TMP}"

log.info "ini_file.set"
#######################

ini_file.set "${INIFILE_TMP}" "section 1" "opt" "a section 1 option"
# cat "${INIFILE_TMP}"
if [[ $(md5sum "${INIFILE_TMP}" | cut -d' ' -f1) == "1f5774dcf9512c3516bded5dfee6cf82" ]]; then
  log.info OK
else
  log.error FAIL
fi

ini_file.set "${INIFILE_TMP}" "__none__" "singleglobal" "__none__"
# cat "${INIFILE_TMP}"
if [[ $(md5sum "${INIFILE_TMP}" | cut -d' ' -f1) == "6825f07cfb548faddcd9ed2bd8ea8c7d" ]]; then
  log.info OK
else
  log.error FAIL
fi

ini_file.set "${INIFILE_TMP}" "section 1" "opt" "a section 1 option - modified"
# cat "${INIFILE_TMP}"
if [[ $(md5sum "${INIFILE_TMP}" | cut -d' ' -f1) == "3f4219e759fa8872b28f1a5ade908a29" ]]; then
  log.info OK
else
  log.error FAIL
fi
# md5sum "${INIFILE_TMP}"

log.info "ini_file.beautify"
############################

cat <<-"EOF" > "${INIFILE_TMP}"


opt=a global option

singleglobal


[section 1]

opt=a section 1 option



[section 2]

opt=a section 2 option


EOF
ini_file.beautify "${INIFILE_TMP}"
# md5sum "${INIFILE_TMP}"
# cat "${INIFILE_TMP}"
if [[ $(md5sum "${INIFILE_TMP}" | cut -d' ' -f1) == "6058b1cd274bc6742cd1fde7e11e04a6" ]]; then
  log.info OK
else
  log.error FAIL
fi

rm -rf "${INIFILE_TMP}"
unset INIFILE_TMP
