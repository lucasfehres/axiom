# PGP

PGP is configured on all personal hosts with a securely stored passphrase. Additionally, the key is available
on YubiKeys.

## Setting up a YubiKey

```
gpg --card-edit

gpg/card> admin
gpg/card> key-attr

(configure ECC 25519 for all key types)

gpg/card> name
gpg/card> lang
gpg/card> salutation
gpg/card> url
gpg/card> login
gpg/card> passwd
```

```
gpg --edit-key DBF4BA5538BF4555E3E8548E8F6F0936E39D9D0E

gpg> keytocard
gpg> keytocard
gpg> key 1
gpg> keytocard
```

## Publishing key

`gpg --keyserver keys.openpgp.org --send-key DBF4BA5538BF4555E3E8548E8F6F0936E39D9D0E`
`gpg --export --armor DBF4BA5538BF4555E3E8548E8F6F0936E39D9D0E`
