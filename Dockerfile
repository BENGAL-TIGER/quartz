
# ψᵟ
#
#
# Originally based on 'base-notebook' from Jupyter Development Team.
#
FROM marcucius/bengal_tiger_lab:quartz@sha256:39cf86666a208909541dad19959baf2d9cb2543f20ea919916221eb230446a6e
# FROM marcucius/bengal_tiger_lab:quartz

LABEL maintainer="mdAshford"

# Hopefully this connects the binder local './notebooks' directory to the container '/user/jovyan/work' directory
copy ./notebooks/  /user/jovyan/work/

USER ${NB_UID}

# Nothing else is needed, since all the Jupyter setup is in the foundation of this Dockerfile
