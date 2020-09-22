# collectd plugins

The following overview presents a list of collectd plugins and their
configuration via TripleO or OSP Director.
All of these plugins can be included in the list of CollectdExtraPlugins
as listed in the examples below. These examples can be combined by simply
adding the plugin to CollectdExtraPlugins and the respective config to
ExtraConfig.

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

The CPU plugin collects the amount of time spent by the CPU in various
states, most notably executing user code, executing system code, waiting
for IO-operations and being idle.

*The CPU plugin does not collect percentages. It collects “jiffies”, 
the units of scheduling. On many Linux systems there are circa 100 
jiffies in one second, but this does not mean you will end up with 
a percentage. Depending on system load, hardware, whether or not the
system is virtualized and possibly half a dozen other factors there
may be more or less than 100 jiffies in one second. There is absolutely
no guarantee that all states add up to 100, an absolute must for
percentages.*

Name | Description| Comment
-----|------------|--------
idle | Amount of idle | collectd_cpu_total{...,type_instance='idle'}
interrupt | cpu blocked by interrupts | collectd_cpu_total{...,type_instance='interrupt'}
nice | amount of time running low priority processes | collectd_cpu_total{...,type_instance='nice'}
softirq | amount of cycles spent in servicing interrupt requests | collectd_cpu_total{...,type_instance='waitirq'}
steal | Steal time is the percentage of time a virtual CPU waits for a real CPU while the hypervisor is servicing another virtual processor. | collectd_cpu_total{...,type_instance='steal'}
system | amount spent on system level (kernel)| collectd_cpu_total{...,type_instance='system'}
user | jiffies used by user processes | collectd_cpu_total{...,type_instance='user'}
wait | cpu waiting on outstanding I/O request | collectd_cpu_total{...,type_instance='wait'}


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

Name | Description| Comment
-----|------------|--------
free | amount of free space | collectd_df_df_complex{..., type_instance="free"}
reserved | reserved disk space | collectd_df_df_complex{..., type_instance="reserved"}
used | used disk space| collectd_df_df_complex{..., type_instance="used"}

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

The following is an example how to use or configure the disk plugin.

    parameter_defaults:
        CollectdExtraPlugins:
          - disk
        ExtraConfig:
            collectd::plugin::disk::disk: "sda"
            collectd::plugin::disk::ignoreselected: false

### interface

    parameter_defaults:
        CollectdExtraPlugins:
          - interface
        ExtraConfig:
            collectd::plugin::interface:

### load

The load plugin collects the system load and gives a rough
overview on the system utilization.

The system load is defined as the number of runnable tasks in
the run-queue.

Name | Description
-----|------------
load_longterm | average system load over the past 15 minues
load_midterm | average system load over the past 5 minutes
load_shortterm | average system load over the last minute

    parameter_defaults:
        CollectdExtraPlugins:
          - load
        ExtraConfig:
            collectd::plugin::load:
### memory

    parameter_defaults:
        CollectdExtraPlugins:
          - memory
        ExtraConfig:
            collectd::plugin::amqp1:
### ovs_stats

    parameter_defaults:
        CollectdExtraPlugins:
          - ovs_stats
        ExtraConfig:
            collectd::plugin::ovs_stats:

### virt

    parameter_defaults:
        CollectdExtraPlugins:
          - virt
        ExtraConfig:
            collectd::plugin::virt1:

## Output plugins

### amqp1

the plugin writes values to an amqp1 message bus, such as qpid.

    parameter_defaults:
        CollectdExtraPlugins:
          - amqp1
        ExtraConfig:
            collectd::plugin::amqp1:

### write_http

The plugin writes data to an HTTP endpoint.

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

## Miscellaneus plugins

### unix

