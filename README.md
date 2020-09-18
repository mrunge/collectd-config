# collectd plugins

## Data collecting plugins

### ceph

The ceph plugin gathers extensive data from ceph daemons.

    parameter_defaults:
        CollectdExtraPlugins:
          - ceph
        ExtraConfig:
            collectd::plugin::ceph::daemons:
               - "ceph-osd.0"
               - "ceph-osd.1"
               - "ceph-osd.2"
               - "ceph-osd.3"
               - "ceph-osd.4"

*Note: the osds have to be listed, even if they don't exist on all nodes.*

More info can be found on the 
[man page](https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_ceph) 
and on the [collectd wiki](https://collectd.org/wiki/index.php/Plugin:Ceph).

### cpu

The CPU plugini collects the amount of time spent by the CPU in various
states, most notably executing user code, executing system code, waiting
for IO-operations and being idle.

    parameter_defaults:
        CollectdExtraPlugins:
          - cpu
        ExtraConfig:
            collectd::plugin::cpu::ReportByState: true

More options to be found at https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_cpu

### df

The DF plugin collects file system usage information, i. e. basically 
how much space on a mounted partition is used and how much is available. 
It's named after and very similar to the df(1) UNIX command that's been around 
forever. 

    parameter_defaults:
        CollectdExtraPlugins:
          - df
        ExtraConfig:
            collectd::plugin::df::FStype: "ext4"

### interface

### disk

### virt

## Output plugins

### amqp1

the plugin writes values to an amqp1 message bus, such as qpid.

    parameter_defaults:
        CollectdExtraPlugins:
          - amqp1
        ExtraConfig:
            collectd::plugin::amqp1:

### write_http

The plugin writes data to an http endpoint.

    parameter_defaults:
        CollectdExtraPlugins:
          - write_http
        ExtraConfig:
            collectd::plugin::write_http::nodes:
                collectd:
                    url: collectd.tld.org
                    metrics: true
                    header: foo

For more options, see https://collectd.org/wiki/index.php/Plugin:Write_HTTP