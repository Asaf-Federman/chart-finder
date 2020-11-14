#! /usr/bin/env bash

set -euo pipefail
OPTIND=1

error(){
    local message="${1}"

    echo "${message}" >&2

    exit 1
}

verifyFlags(){
    local repository_name="${1}"
    local chart="${2}"
    local app_version="${3}"

    [[ -n "${repository_name}" ]] || error "Repository name is a mandatory field"
    [[ -n "${chart}" ]] || error "Chart name is a mandatory field"    
    [[ -n "${app_version}" ]] || error "Application version is a mandatory field"    
}

usage="This script is used to fetch the latest chart version of a specific app version

where:
    -h -- help
    -n -- repository's name (Mandatory)
    -m -- chart's name (Mandatory)
    -v -- applications's version (Mandatory)
    -a -- repository's url  (Optional - needed incase of adding a new repository)
    -u -- username (Optional - incase a private repository needs to be added)
    -p -- password (Optional - incase a private repository needs to be added)
    
    Example: './chart_finder.sh -n center -a https://repo.chartcenter.io -v 6.5.9 -m jfrog/artifactory'"
repository_url=
username=
password=
repository_name=
chart=
app_version=
    
while getopts 'n:m:v:a:u:p:h' option; do
  case "${option}" in
    h) echo "${usage}"
       exit 0
       ;;
    n) repository_name="${OPTARG}"
       ;;
    a) repository_url="${OPTARG}"
       ;;
    v) app_version="${OPTARG}"
       ;;
    m) chart="${OPTARG}"
       ;;
    u) username="${OPTARG}"
       ;;
    p) password="${OPTARG}"
       ;;
    *) echo "illegal option: ${OPTARG}" >&2
       echo "${usage}" >&2
       exit 1
       ;;
  esac
done

verifyFlags "${repository_name}" "${chart}" "${app_version}"
if [[ -n "${repository_url}" ]]; then
   credentials=
    if [[ -n "${username}" && -n "${password}" ]]; then
        credentials="--username ${username} --password ${password}"
    fi
    
    helm repo add "${repository_name}" "${repository_url}" ${credentials} 1> /dev/null || error "Failed to add ${repository_name} ${repository_url} as a new helm repository"
else
    [[ -n $(awk ' $1 == "'"${repository_name}"'" ' <<< "$(helm repo list)") ]] || error "Can not find a helm repository named: ${repository_name}"
fi

helm repo update 1> /dev/null || error "Failed to update the helm repositories"
result=$(helm search repo -l -r "${repository_name}/${chart}[^-]" | awk ' $3 == "'"${app_version}"'" ' | head -n 1 | awk '{print $2}')
if [[ -n ${result} ]]; then
   echo "${result}"
else
   error "No matching chart version was found for ${repository_name}/${chart} appVersion: v${app_version}"
fi