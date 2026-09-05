#FROM quay.io/fedora-ostree-desktops/cosmic-atomic:44
#FROM quay.io/fedora-ostree-desktops/kinoite:44
FROM quay.io/fedora-ostree-desktops/silverblue:44

RUN --mount=type=bind,source=resources,target=/tmp/resources,relabel=shared \
    --mount=type=bind,source=scripts,target=/tmp/scripts,relabel=shared \
    --mount=type=cache,destination=/var/cache/libdnf5 \
    --mount=type=cache,destination=/var/lib/dnf \
    --mount=type=tmpfs,destination=/var/log \
    <<EOF

# bash safety options
set -euox pipefail

# actions to perform before everything else
bash /tmp/scripts/pre.sh

# run common configuration
bash /tmp/scripts/common.sh

# run desktop-specific configuration
#bash /tmp/scripts/cosmic.sh
#bash /tmp/scripts/kinoite.sh
bash /tmp/scripts/silverblue.sh

# actions to perform after everything else
bash /tmp/scripts/post.sh

EOF

RUN bootc container lint
