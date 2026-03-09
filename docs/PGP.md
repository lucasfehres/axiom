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

Also put the key on GitHub and in the well-known.

## Keys

| Fingerprint                              | Description | Where                            | Valid until |
| ---------------------------------------- | ----------- | -------------------------------- | ----------- |
| DBF4BA5538BF4555E3E8548E8F6F0936E39D9D0E | Master (CS) | D2760001240100000006312237200000 | Unlimited   |
| 5D85EA6AFD452A3C9ECA52065BEFE6DA8F9C973A | Master (E)  | D2760001240100000006312237200000 | 07-03-2029  |
| 82390F272D804DD1E975D282D6A07A70039362CC | Usable (S)  | Nix, FW13                        | 09-03-2027  |
| DCC14E00541EAD479DCED45C30288B8E4C2F50F4 | Usable (A)  | Nix, FW13                        | 09-03-2027  |
