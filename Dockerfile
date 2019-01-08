
# ψᵟ
#
#
# Originally based on 'base-notebook' from Jupyter Development Team.
#
FROM marcucius/bengal_tiger_lab:quartz@sha256:5385ee3c892c572a869e383382550aa71983f17bcb92d3b571fe2d8d10a0ba73
# FROM marcucius/bengal_tiger_lab:quartz

LABEL maintainer="mdAshford"

USER ${NB_UID}

# Hopefully this connects the binder local './notebooks' directory to the container '/user/jovyan/work' directory
copy ./notebooks/  $HOME/work/

# Nothing else is needed, since all the Jupyter setup is in the foundation of this Dockerfile
#
# _____ wrap up and go home ____________________________________
env JUPYTER_ENABLE_LAB=TRUE
# env USER=$NB_USER
# workdir /user/jovyan/work
workdir $HOME/work
