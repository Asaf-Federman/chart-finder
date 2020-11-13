FROM alpine/helm:3.4.1
RUN apk add --no-cache bash
COPY './chart_finder.sh' '/chart_finder.sh' 
ENTRYPOINT ["/chart_finder.sh"]