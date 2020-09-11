#!/bin/bash
set -euo pipefail

# Colorful output.
function greenprint {
  echo -e "\033[1;32m${1}\033[0m"
}

ARCH=$(uname -m)

curl -L http://download.devel.redhat.com/rhel-8/nightly/RHEL-8/latest-RHEL-8/COMPOSE_ID > COMPOSE_ID
COMPOSE_ID=$(cat COMPOSE_ID)

# Create a repository file for installing the osbuild-composer RPMs
greenprint "📜 Generating dnf repository file"
tee osbuild-mock.repo << EOF
[rhel8-nightly-baseos]
name=${COMPOSE_ID} BaseOS
baseurl=http://download.devel.redhat.com/rhel-8/nightly/RHEL-8/${COMPOSE_ID}/compose/BaseOS/${ARCH}/os
enabled=1
gpgcheck=0
# Default dnf repo priority is 99. Lower number means higher priority.
priority=5

[rhel8-nightly-appstream]
name=${COMPOSE_ID} AppStream
baseurl=http://download.devel.redhat.com/rhel-8/nightly/RHEL-8/${COMPOSE_ID}/compose/AppStream/${ARCH}/os
enabled=1
gpgcheck=0
# Default dnf repo priority is 99. Lower number means higher priority.
priority=5
EOF


# Create an osbuild-composer JSON file for content consumption
greenprint "📜 Generate osbuild-composer JSON source file"
tee rhel-8.json << EOF
{
    "${ARCH}": [
        {
            "name": "baseos",
            "baseurl": "http://download.devel.redhat.com/rhel-8/nightly/RHEL-8/${COMPOSE_ID}/compose/BaseOS/${ARCH}/os",
            "gpgkey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nmQINBErgSTsBEACh2A4b0O9t+vzC9VrVtL1AKvUWi9OPCjkvR7Xd8DtJxeeMZ5eF\n0HtzIG58qDRybwUe89FZprB1ffuUKzdE+HcL3FbNWSSOXVjZIersdXyH3NvnLLLF\n0DNRB2ix3bXG9Rh/RXpFsNxDp2CEMdUvbYCzE79K1EnUTVh1L0Of023FtPSZXX0c\nu7Pb5DI5lX5YeoXO6RoodrIGYJsVBQWnrWw4xNTconUfNPk0EGZtEnzvH2zyPoJh\nXGF+Ncu9XwbalnYde10OCvSWAZ5zTCpoLMTvQjWpbCdWXJzCm6G+/hx9upke546H\n5IjtYm4dTIVTnc3wvDiODgBKRzOl9rEOCIgOuGtDxRxcQkjrC+xvg5Vkqn7vBUyW\n9pHedOU+PoF3DGOM+dqv+eNKBvh9YF9ugFAQBkcG7viZgvGEMGGUpzNgN7XnS1gj\n/DPo9mZESOYnKceve2tIC87p2hqjrxOHuI7fkZYeNIcAoa83rBltFXaBDYhWAKS1\nPcXS1/7JzP0ky7d0L6Xbu/If5kqWQpKwUInXtySRkuraVfuK3Bpa+X1XecWi24JY\nHVtlNX025xx1ewVzGNCTlWn1skQN2OOoQTV4C8/qFpTW6DTWYurd4+fE0OJFJZQF\nbuhfXYwmRlVOgN5i77NTIJZJQfYFj38c/Iv5vZBPokO6mffrOTv3MHWVgQARAQAB\ntDNSZWQgSGF0LCBJbmMuIChyZWxlYXNlIGtleSAyKSA8c2VjdXJpdHlAcmVkaGF0\nLmNvbT6JAjYEEwECACAFAkrgSTsCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAK\nCRAZni+R/UMdUWzpD/9s5SFR/ZF3yjY5VLUFLMXIKUztNN3oc45fyLdTI3+UClKC\n2tEruzYjqNHhqAEXa2sN1fMrsuKec61Ll2NfvJjkLKDvgVIh7kM7aslNYVOP6BTf\nC/JJ7/ufz3UZmyViH/WDl+AYdgk3JqCIO5w5ryrC9IyBzYv2m0HqYbWfphY3uHw5\nun3ndLJcu8+BGP5F+ONQEGl+DRH58Il9Jp3HwbRa7dvkPgEhfFR+1hI+Btta2C7E\n0/2NKzCxZw7Lx3PBRcU92YKyaEihfy/aQKZCAuyfKiMvsmzs+4poIX7I9NQCJpyE\nIGfINoZ7VxqHwRn/d5mw2MZTJjbzSf+Um9YJyA0iEEyD6qjriWQRbuxpQXmlAJbh\n8okZ4gbVFv1F8MzK+4R8VvWJ0XxgtikSo72fHjwha7MAjqFnOq6eo6fEC/75g3NL\nGht5VdpGuHk0vbdENHMC8wS99e5qXGNDued3hlTavDMlEAHl34q2H9nakTGRF5Ki\nJUfNh3DVRGhg8cMIti21njiRh7gyFI2OccATY7bBSr79JhuNwelHuxLrCFpY7V25\nOFktl15jZJaMxuQBqYdBgSay2G0U6D1+7VsWufpzd/Abx1/c3oi9ZaJvW22kAggq\ndzdA27UUYjWvx42w9menJwh/0jeQcTecIUd0d0rFcw/c1pvgMMl/Q73yzKgKYw==\n=zbHE\n-----END PGP PUBLIC KEY BLOCK-----\n-----BEGIN PGP PUBLIC KEY BLOCK-----\n\n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\nvt61kpkXoRGxjTlc6h+69aidSg==\n=ls8J\n-----END PGP PUBLIC KEY BLOCK-----\n"
        },
        {
            "name": "appstream",
            "baseurl": "http://download.devel.redhat.com/rhel-8/nightly/RHEL-8/${COMPOSE_ID}/compose/AppStream/${ARCH}/os",
            "gpgkey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nmQINBErgSTsBEACh2A4b0O9t+vzC9VrVtL1AKvUWi9OPCjkvR7Xd8DtJxeeMZ5eF\n0HtzIG58qDRybwUe89FZprB1ffuUKzdE+HcL3FbNWSSOXVjZIersdXyH3NvnLLLF\n0DNRB2ix3bXG9Rh/RXpFsNxDp2CEMdUvbYCzE79K1EnUTVh1L0Of023FtPSZXX0c\nu7Pb5DI5lX5YeoXO6RoodrIGYJsVBQWnrWw4xNTconUfNPk0EGZtEnzvH2zyPoJh\nXGF+Ncu9XwbalnYde10OCvSWAZ5zTCpoLMTvQjWpbCdWXJzCm6G+/hx9upke546H\n5IjtYm4dTIVTnc3wvDiODgBKRzOl9rEOCIgOuGtDxRxcQkjrC+xvg5Vkqn7vBUyW\n9pHedOU+PoF3DGOM+dqv+eNKBvh9YF9ugFAQBkcG7viZgvGEMGGUpzNgN7XnS1gj\n/DPo9mZESOYnKceve2tIC87p2hqjrxOHuI7fkZYeNIcAoa83rBltFXaBDYhWAKS1\nPcXS1/7JzP0ky7d0L6Xbu/If5kqWQpKwUInXtySRkuraVfuK3Bpa+X1XecWi24JY\nHVtlNX025xx1ewVzGNCTlWn1skQN2OOoQTV4C8/qFpTW6DTWYurd4+fE0OJFJZQF\nbuhfXYwmRlVOgN5i77NTIJZJQfYFj38c/Iv5vZBPokO6mffrOTv3MHWVgQARAQAB\ntDNSZWQgSGF0LCBJbmMuIChyZWxlYXNlIGtleSAyKSA8c2VjdXJpdHlAcmVkaGF0\nLmNvbT6JAjYEEwECACAFAkrgSTsCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAK\nCRAZni+R/UMdUWzpD/9s5SFR/ZF3yjY5VLUFLMXIKUztNN3oc45fyLdTI3+UClKC\n2tEruzYjqNHhqAEXa2sN1fMrsuKec61Ll2NfvJjkLKDvgVIh7kM7aslNYVOP6BTf\nC/JJ7/ufz3UZmyViH/WDl+AYdgk3JqCIO5w5ryrC9IyBzYv2m0HqYbWfphY3uHw5\nun3ndLJcu8+BGP5F+ONQEGl+DRH58Il9Jp3HwbRa7dvkPgEhfFR+1hI+Btta2C7E\n0/2NKzCxZw7Lx3PBRcU92YKyaEihfy/aQKZCAuyfKiMvsmzs+4poIX7I9NQCJpyE\nIGfINoZ7VxqHwRn/d5mw2MZTJjbzSf+Um9YJyA0iEEyD6qjriWQRbuxpQXmlAJbh\n8okZ4gbVFv1F8MzK+4R8VvWJ0XxgtikSo72fHjwha7MAjqFnOq6eo6fEC/75g3NL\nGht5VdpGuHk0vbdENHMC8wS99e5qXGNDued3hlTavDMlEAHl34q2H9nakTGRF5Ki\nJUfNh3DVRGhg8cMIti21njiRh7gyFI2OccATY7bBSr79JhuNwelHuxLrCFpY7V25\nOFktl15jZJaMxuQBqYdBgSay2G0U6D1+7VsWufpzd/Abx1/c3oi9ZaJvW22kAggq\ndzdA27UUYjWvx42w9menJwh/0jeQcTecIUd0d0rFcw/c1pvgMMl/Q73yzKgKYw==\n=zbHE\n-----END PGP PUBLIC KEY BLOCK-----\n-----BEGIN PGP PUBLIC KEY BLOCK-----\n\n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\nvt61kpkXoRGxjTlc6h+69aidSg==\n=ls8J\n-----END PGP PUBLIC KEY BLOCK-----\n"
        }
    ]
}
EOF

cp rhel-8.json rhel-8-beta.json


greenprint "📦 Installing requirements"
sudo dnf -y install createrepo_c wget python3-pip

# Install s3cmd if it is not present.
if ! s3cmd --version > /dev/null 2>&1; then
    greenprint "📦 Installing s3cmd"
    sudo pip3 -q install s3cmd
fi

REPO_DIR_LATEST="repo/${JOB_NAME}/latest/nightly"
mkdir -p "$REPO_DIR_LATEST"

greenprint "Discover latest osbuild-composer NVR"
# Download only osbuild-composer-worker-*.rpm and use it in rpm --qf below
wget --quiet --recursive --no-parent --no-directories --accept "osbuild-composer-worker-*.rpm" \
    "http://download.devel.redhat.com/rhel-8/nightly/RHEL-8/${COMPOSE_ID}/compose/AppStream/${ARCH}/os/Packages/"

# Download osbuild-composer-tests from Brew b/c it is not available in the distro
# version matches osbuild-composer from the nightly tree
greenprint "Downloading osbuild-composer-tests from Brew"
TESTS_RPM_URL=$(rpm -qp ./osbuild-composer-worker-*.rpm --qf "http://download.devel.redhat.com/brewroot/vol/rhel-8/packages/osbuild-composer/%{version}/%{release}/%{arch}/osbuild-composer-tests-%{version}-%{release}.%{arch}.rpm")
wget --directory-prefix "$REPO_DIR_LATEST" "$TESTS_RPM_URL"

greenprint "⛓ Creating dnf repository"
createrepo_c "${REPO_DIR_LATEST}"

# Bucket in S3 where our artifacts are uploaded
REPO_BUCKET=osbuild-composer-repos

# Remove the previous latest repo for this job.
# Don't fail if the path is missing.
s3cmd --recursive rm "s3://${REPO_BUCKET}/${REPO_DIR_LATEST}" || true

# Upload repository to S3.
greenprint "☁ Uploading RPMs to S3"
s3cmd --acl-public sync . s3://${REPO_BUCKET}/

# Public URL for the S3 bucket with our artifacts.
MOCK_REPO_BASE_URL="http://osbuild-composer-repos.s3-website.us-east-2.amazonaws.com"

# Full URL to the RPM repository after they are uploaded.
REPO_URL=${MOCK_REPO_BASE_URL}/${REPO_DIR_LATEST}

# amend repository file.
greenprint "📜 Amend dnf repository file"
tee -a osbuild-mock.repo << EOF
[osbuild-mock]
name=osbuild mock ${JOB_NAME}
baseurl=${REPO_URL}
enabled=1
gpgcheck=0
# Default dnf repo priority is 99. Lower number means higher priority.
priority=5
EOF
