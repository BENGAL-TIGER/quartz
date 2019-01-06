
# ψᵟ
#
#
# Based on base-notebook from Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
#
FROM marcucius/bengal_tiger:201812192357
# FROM marcucius/bengal_tiger_lab:quartz

LABEL maintainer="mdAshford"

# RUN pip install --no-cache-dir notebook==5.*

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

workdir /user/jovyan/work
