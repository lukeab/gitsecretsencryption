# Example encryption techniques for working with secure secrets in git repositories

Primarily this will be a demo of how to use [sops](https://github.com/mozilla/sops) from mozilla, but we will look into how to couple this with a tool like [git-secrets](https://github.com/awslabs/git-secrets) to help ensure secrets are not shipped to git un-encrypted.

## Key Management
To manage keys there are a number of methods: 
* PGP (gpg)- this uses a shared key that can be accessed and shared around like any gpg key
* AWS - KMS keys in aws can be used directly with sops, so this can be very useful for a production environments
* other clouds - gcp/azure - compatible with all 3 major cloud providers.


## Setup this scirpt
### Using PGP/GPG
export a gpg ID to the environment variable `SOPS_PGP_FP`

```bash
export SOPS_PGP_FP=3BDFF3F9E49BB3D457B38CFFB379D8953429FDEB
```

this ID can be retrieved using the `gpg` command

```bash
$> gpg --list-secret-keys
/home/luke/.gnupg/pubring.kbx
-----------------------------
sec   rsa4096 2019-07-03 [SC]
      3BDFF3F9E49BB3D457B38CFFB379D8953429FDEB
uid           [ultimate] lukeashebrowne@domain.com (luke ashebrowne gpg key) <luke@domain.com>
ssb   rsa4096 2019-07-03 [E]

```

You may see multiple keys in the keychain, but you should use one you own, has your name/email on it, and one that isn't likely to expire soon.

If you don't see one in your keychain, you can create one:

```bash

gpg --full-generate-key


Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: Luke Ashe-Browne
Email address: luke@domain.com
Comment:
You selected this USER-ID:
    "Luke Ashe-Browne <luke@domain.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
... generating key ...

gpg: key 0954AFBD84AD4B85 marked as ultimately trusted
gpg: revocation certificate stored as '/home/luke/.gnupg/openpgp-revocs.d/83BFC84EFA98B9284D3939220954AFBD84AD4B85.rev'
public and secret key created and signed.

pub   rsa4096 2019-08-27 [SC]
      83BFC84EFA98B9284D3939220954AFBD84AD4B85
uid                      Luke Ashe-Browne <luke@domain.com>
sub   rsa4096 2019-08-27 [E]

```

`assumes gpg v >= 2.1.17`

### AWS KMS