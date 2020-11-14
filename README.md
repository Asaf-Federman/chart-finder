## CHART FINDER

 **This docker image is used to find the latest chart version of a given application version**

### ***Usage:*** 

1. Start the container by `docker run [docker flags] asaff/chart_finder:[tag] [script flags]`

### ***Options and Flags:*** 

    -h -- help
    -n -- repository's name (Mandatory)
    -m -- chart's name (Mandatory)
    -v -- applications's version (Mandatory)
    -a -- repository's url  (Optional - Needed incase of adding a new repository)
    -u -- username (Optional - incase a private repository needs to be added)
    -p -- password (Optional - incase a private repository needs to be added)

### ***Examples:*** 

#### to add a new chart

    docker run chart_finder:latest -n center -a https://repo.chartcenter.io -v 6.5.9 -m jfrog/artifactory
    7.7.12

#### to use existing charts

    docker run -v ~/.config/helm:/root/.config/helm -v ~/.cache/helm:/root/.cache/helm asaff/chart_finder -n center -v 3.8.8 -m jfrog/xray
    6.0.6

### ***NOTES:***

1. Based on alpine/helm:3.4.1
1. Docker installed is a requirement