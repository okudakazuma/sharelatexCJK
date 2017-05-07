FROM sharelatex/sharelatex:latest
MAINTAINER OKUDA Kazuma
ENV SLROOT /var/www/sharelatex
ADD sharelatexCJK ${SLROOT}
WORKDIR ${SLROOT}
# RUN ./installCJK.sh patch 
RUN ./CJK-localization.sh patch 
