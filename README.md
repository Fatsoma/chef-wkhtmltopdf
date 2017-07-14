# chef-wkhtmltopdf

## Description

Installs [wkhtmltopdf](http://wkhtmltopdf.org) static binaries. This cookbook is inspired by https://github.com/firstbanco/chef-wkhtmltopdf.

Cookbook Compatibility:
 * chef-wkhtmltopdf 0.1.0: wkhtmltopdf 0.11.0_rc1
 * chef-wkhtmltopdf 0.2.0: wkhtmltopdf 0.12.0
 * chef-wkhtmltopdf 0.3.0: wkhtmltopdf 0.12.1
 * chef-wkhtmltopdf 0.4.0: wkhtmltopdf 0.12.1 to 0.12.4

## Requirements

### Platforms

* CentOS 6
* RedHat 6
* Ubuntu 12.04
* Ubuntu 14.04

### Chef

* Chef 11+

### Cookbooks

[Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [apt](https://github.com/opscode-cookbooks/apt)

## Attributes

These attributes are under the `node['wkhtmltopdf']` namespace.

Attribute      | Description                      | Type   | Default
---------------|----------------------------------|--------|--------
`archive`      | wkhtmltopdf archive name         | String | `wkhtmltox-#{node['wkhtmltopdf']['version']}_#{node['wkhtmltopdf']['platform']}-#{node['wkhtmltopdf']['architecture']}.#{node['wkhtmltopdf']['suffix']}`
`dependency_packages` | Packages that contain wkhtmltopdf dependencies | String | (auto-detected, see attributes/default.rb)
`install_dir`  | directory to install with source | String | `/usr/local/bin`
`lib_dir`      | directory to install libraries   | String | `''`
`mirror_url`   | URL for wkhtmltopdf              | String | (auto-detected, see attributes/default.rb)
`suffix`       | wkhtmltopdf suffix               | String | (auto-detected, see attributes/default.rb)
`platform`     | wkhtmltopdf platform             | String | (auto-detected, see attributes/default.rb)
`architecture` | wkhtmltopdf architecture         | String | (auto-detected, see attributes/default.rb)
`version`      | wkhtmltopdf version to install   | String | 0.12.4

## Recipes

* `recipe[wkhtmltopdf]` Installs wkhtmltoimage and wkhtmltopdf using install method from `node['wkhtmltopdf']['install_method']`
* `recipe[wkhtmltopdf::binary]` Installs wkhtmltoimage and wkhtmltopdf static binaries
* `recipe[wkhtmltopdf::source]` Installs wkhtmltoimage and wkhtmltopdf from source

## Usage

* Add recipe(s) to node's run list

## Testing and Development

Here's how you can quickly get testing or developing against the cookbook thanks to [chefspec](https://chefspec.github.io/chefspec/) and [test-kitchen](http://kitchen.ci/).

    git clone git://github.com/Fatsoma/chef-wkhtmltopdf.git
    cd chef-wkhtmltopdf

Run chefspec with:

    rspec

Find kitchen suites (from `.kitchen.yml`) and run them (specifying by `NAME`):

    kitchen list
    kitchen test NAME

You can bring up a VM to login to with (specifying `NAME`):

    kitchen test -d never NAME
    kitchen login NAME
    kitchen destroy NAME

## Contributing

Please use standard Github issues/pull requests and if possible, in combination with testing using chefspec and test-kitchen.

## Maintainers

* Bill Ruddock (bill.ruddock@fatsoma.com)
* Brian Flad (bflad417@gmail.com)

## License

Please see licensing information in: [LICENSE](LICENSE)
