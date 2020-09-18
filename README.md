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

The Disk plugin collects performance statistics of hard-disks and, where 
supported, partitions. While the “octets” and “operations” are quite straight 
forward, the other two datasets need a little explanation:

* “merged” are the number of operations, that could be merged into other,
   already queued operations, i. e. one physical disk access served two 
   or more logical operations. Of course, the higher that number, the better.

* “time” is the average time an I/O-operation took to complete. Since this is
  a little messy to calculate take the actual values with a grain of salt.

* “io_time” - time spent doing I/Os (ms). You can treat this metric as a 
   device load percentage (Value of 1 sec time spent matches 100% of load).

* “weighted_io_time” - measure of both I/O completion time and the backlog 
   that may be accumulating.
* “pending_operations” - shows queue size of pending I/O operations.


    parameter_defaults:
        CollectdExtraPlugins:
          - disk
        ExtraConfig:
            collectd::plugin::disk::disk: "sda"
            collectd::plugin::disk::ignoreselected: false

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
