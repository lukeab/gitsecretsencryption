DEFAULT: encrypt

#TODO
# Windows support for curl? maybe just error on windows?
#Needs make to runint he first place.

ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
    detected_OS := Windows
else
    detected_OS := $(shell uname)  # same as "uname -s"
endif
ifeq ($(detected_OS),Windows)
    SOPSPLATFORM := exe
endif
ifeq ($(detected_OS),Darwin)        # Mac OS X
    SOPSPLATFORM := darwin
endif
ifeq ($(detected_OS),Linux)			# linux OS
    SOPSPLATFORM := linux
endif

SOPSVERSION := 3.3.1

PATH := vendor/bin:${PATH}
SOPS_KMS_ARN ?=
SOPS_PGP_FP ?=

deps:
	@if [[ "${detected_OS}" = "Windows" ]]; then echo "WARNING: Windows is not supported, this may not work!!"; fi
	@mkdir -p vendor/bin
	@[ ! -f vendor/bin/sops ] && curl -Lo vendor/bin/sops https://github.com/mozilla/sops/releases/download/${SOPSVERSION}/sops-${SOPSVERSION}.${SOPSPLATFORM} && chmod +x vendor/bin/sops || true

encrypt: deps
	sops -e afileofsecrets.yaml.test > afileofsecrets.yaml

encrypt_inplace:
	cp afileofsecrets.yaml.test inplacesecrets.yaml
	sops -e -i inplacesecrets.yaml

decrypt_and_print_file:
	test -f afileofsecrets.yaml 
	sops -d afileofsecrets.yaml

decrypt_and_print_inplace_file:
	test -f inplacesecrets.yaml
	sops -d inplacesecrets.yaml

encrypt_kms: deps
	sops -k -e afileofsecrets.yaml.test > afileofsecrets_kms.yaml

decrypt_and_print_file_kms:
	test -f afileofsecrets_kms.yaml
	sops -k -d afileofsecrets_kms.yaml

sops_help:
	sops --help