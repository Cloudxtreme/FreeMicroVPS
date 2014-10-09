freemicrovps Cookbook
=====================
Set up the main FreeMicroVPS server.

Requirements
------------
- Ubuntu 14.04
- /dev/sda3 - unused partition for virtual machines
- Ubuntu packages: chef ruby-shadow

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### freemicrovps::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['freemicrovps']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
Run this cookbook on a fresh Ubuntu 14.04 machine with an unused partition.

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
