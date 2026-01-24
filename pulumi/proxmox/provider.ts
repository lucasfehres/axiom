import * as proxmox from "@muhlba91/pulumi-proxmoxve";
import * as pulumi from "@pulumi/pulumi"

const cfg = new pulumi.Config()

export default new proxmox.Provider("proxmox", {
    endpoint: cfg.getSecret("PROXMOX_VE_ENDPOINT"),
    username: cfg.getSecret("PROXMOX_VE_USERNAME"),
    password: cfg.getSecret("PROXMOX_VE_PASSWORD"),
});
