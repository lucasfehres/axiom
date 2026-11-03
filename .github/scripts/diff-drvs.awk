# Filters `nix store diff-closures` output run on .drv paths down to package
# version changes: drops sources, patches, bootstrap stages and size-only lines,
# and merges packages whose name embeds an interpreter version (perl5.42.0-Foo).
function clean(side,   n, parts, i, out, t) {
    n = split(side, parts, ", ")
    out = ""
    for (i = 1; i <= n; i++) {
        t = parts[i]
        sub(/\.drv$/, "", t)
        if (t == "∅" || t ~ src_re || t ~ /^(source|src)$/) continue
        out = out (out == "" ? "" : ", ") t
    }
    return out
}
BEGIN { src_re = "\\.(tar(\\.[a-z0-9]+)?|tgz|tbz2?|txz|zip|patch|diff|gem|crate|whl)(\\?.*)?$" }
{
    gsub(/\033\[[0-9;]*m/, "")
    if (index($0, " → ") == 0) next
    colon = index($0, ": ")
    name = substr($0, 1, colon - 1)
    sub(/\.drv$/, "", name)
    if (name ~ src_re || name ~ /^(bootstrap-|nixos-system-)|^(CVE|cve)$/) next
    if (match(name, /^(perl|python|ruby|php|lua)[0-9.]+-/)) {
        ver = substr(name, 1, RLENGTH - 1)
        name = substr(name, RLENGTH + 1) " (" ver ")"
        sub(/[0-9.]+\)$/, ")", name)
    }
    rest = substr($0, colon + 2)
    arrow = index(rest, " → ")
    o = clean(substr(rest, 1, arrow - 1)); n = clean(substr(rest, arrow + length(" → ")))
    if (o != "") old[name] = old[name] (old[name] == "" ? "" : ", ") o
    if (n != "") new[name] = new[name] (new[name] == "" ? "" : ", ") n
    seen[name] = 1
}
END {
    for (name in seen) {
        if (old[name] == new[name]) continue
        print name ": " (old[name] == "" ? "∅" : old[name]) " → " (new[name] == "" ? "∅" : new[name])
    }
}
