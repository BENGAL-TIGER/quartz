
# ψᵟ
#
#
# Based on base-notebook from Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
#
FROM marcucius/bengal_tiger_lab:quartz

LABEL maintainer="mdAshford"


env USER=$NB_USER
workdir /user/jovyan/work
