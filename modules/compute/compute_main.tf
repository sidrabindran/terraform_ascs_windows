# refer to a resource group
data "azurerm_resource_group" "rg" {
  name = "${var.rg}"
}

#refer to a subnet
data "azurerm_subnet" "subnet" {
  name                 = "${var.subnetname}"
  virtual_network_name = "${var.vnetname}"
  resource_group_name  = "${var.networkrg}"
}

# create a primary network interface
resource "azurerm_network_interface" "primary" {
  name                = "${var.vmname}_nic_1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_servers         = var.dns_server
  ip_configuration {
    name                                     = "${var.vmname}_ipconfig"
    subnet_id                                = data.azurerm_subnet.subnet.id
    private_ip_address_allocation            = "dynamic"
    primary                                  = true
  }
}

#Create disk

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.vmname}_datadisk_${count.index}"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.datadisksize
  count                = var.datadiskcount
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "vm" {
    name                  = var.vmname
    location              = azurerm_network_interface.primary.location
    resource_group_name   = data.azurerm_resource_group.rg.name
    network_interface_ids = ["${azurerm_network_interface.primary.id}"]
    size               = var.vmsize
    availability_set_id   = var.avset_id
    admin_username = var.admin
    admin_password = var.password
    
  source_image_reference {
    publisher = "${var.ospublisher}"
    offer     = "${var.osoffer}"
    sku       = "${var.ossku}"
    version   = "${var.osversion}"
  }
   os_disk {
    caching             = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  
}
resource "azurerm_virtual_machine_data_disk_attachment" "datadisk" {
  count              = var.datadiskcount
  managed_disk_id    = element(azurerm_managed_disk.datadisk.*.id, count.index)
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = count.index
  caching            = "ReadOnly"
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  network_interface_id    = azurerm_network_interface.primary.id
  ip_configuration_name   = "${var.vmname}_ipconfig"
  backend_address_pool_id = var.backend_ip_id
}