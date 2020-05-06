variable "rg" {
    description = "resource group"
}

variable "networkrg" {
    description = "resource group where network is deployed"
}

variable "vnetname"{
    description = " name of the virtual"
}

variable "subnetname" {
    description = " name of the subnet"
}

variable "datadisksize"{
    description = "size of datadisks"
}

variable "datadiskcount"{
    description = "no of datadisks"
}
variable "vmsize"{
    description = "size of VM"
}

variable "vmname"{
    description = "name of the VM"
}

variable "ospublisher" {
    description = "Operating system publisher ex:SUSE"
}

variable "osoffer" {
    description = "Operating system SKU offer ex: SLES-SAP"  
}

variable "ossku" {
    description = "Operating system SKU ex: 12-SP3"
}

variable "osversion"{
    description = "Operating system versin ex: latest"
}

variable "admin"{
    description = "admin user name"
}

variable "password"{
    description = "password of the vm"
}

variable "avset_id"{
    description = "id for avset"
}

variable "backend_ip_id"{
    description = "id for backendpool"
}