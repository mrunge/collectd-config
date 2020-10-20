# collectd plugins

The following overview presents a list of collectd plugins and their
configuration via TripleO or OSP Director.
All of these plugins can be included in the list of CollectdExtraPlugins
as listed in the examples below. These examples can be combined by simply
adding the plugin to CollectdExtraPlugins and the respective config to
ExtraConfig.

## Global options

### CollectInternalStats *(false|true)*

When set to true, various statistics about the collectd daemon will be
collected, with "collectd" as the plugin name. Defaults to false.

### Interval *seconds*
Configures the interval in which to query the read plugins. Obviously smaller
values lead to a higher system load produced by collectd, while higher values
lead to more coarse statistics.


### WriteQueueLimitHigh *num*
### WriteQueueLimitLow *num*

Metrics are read by the read threads and then put into a queue to be handled
by the write threads. If one of the write plugins is slow (e.g. network
timeouts, I/O saturation of the disk) this queue will grow. In order to
avoid running into memory issues in such a case, you can limit the size of
this queue.

By default, there is no limit and memory may grow indefinitely. This is most
likely not an issue for clients, i.e. instances that only handle the local
metrics. For servers it is recommended to set this to a non-zero value, though.

You can set the limits using WriteQueueLimitHigh and WriteQueueLimitLow.
Each of them takes a numerical argument which is the number of metrics in
the queue. If there are HighNum metrics in the queue, any new metrics will
be dropped. If there are less than LowNum metrics in the queue, all new
metrics will be enqueued. If the number of metrics currently in the
queue is between LowNum and HighNum, the metric is dropped with a probability
that is proportional to the number of metrics in the queue (i.e. it increases
linearly until it reaches 100%.)

If WriteQueueLimitHigh is set to non-zero and WriteQueueLimitLow is unset,
the latter will default to half of WriteQueueLimitHigh.

If you do not want to randomly drop values when the queue size is between
LowNum and HighNum, set WriteQueueLimitHigh and WriteQueueLimitLow to the
same value.

Enabling the CollectInternalStats option is of great help to figure out
the values to set WriteQueueLimitHigh and WriteQueueLimitLow to.

    parameter_defaults:
        ExtraConfig:
          collectd::write_queue_limit_high: 100
          collectd::write_queue_limit_low: 100


## Data collecting plugins

### ceph

The ceph plugin gathers extensive data from ceph daemons.

    parameter_defaults:
        ExtraConfig:
            collectd::plugin::ceph::daemons:
               - "ceph-osd.0"
               - "ceph-osd.1"
               - "ceph-osd.2"
               - "ceph-osd.3"
               - "ceph-osd.4"

*Note: the osds have to be listed, even if they don't exist on all nodes.*

*Note: The ceph plugin will be added automatically on ceph nodes, when collectd
is deployed. Adding the ceph plugin on ceph nodes to CollectdExtraPlugins will
result in a deployment failure.

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


The following values are reported by the CPU plugin:

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

The following values are reported by the df plugin:

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

### disk

The Disk plugin collects performance statistics of hard-disks and, where
supported, partitions. While the “octets” and “operations” are quite
straight forward, the other two datasets need a little explanation:

Name | Description
-----|------------
merged | are the number of operations, that could be merged into other, already queued operations, i. e. one physical disk access served two or more logical operations. Of course, the higher that number, the better.
time | is the average time an I/O-operation took to complete. Since this is a little messy to calculate take the actual values with a grain of salt.
io_time | time spent doing I/Os (ms). You can treat this metric as a device load percentage (Value of 1 sec time spent matches 100% of load).
weighted_io_time | measure of both I/O completion time and the backlog that may be accumulating.
pending_operations | shows queue size of pending I/O operations.

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

### ovs_stats

Open vSwitch, sometimes abbreviated as OvS, is a production-quality
open-source implementation of a distributed virtual multi-layer switch.
The main purpose of Open vSwitch is to provide a switching stack for
hardware virtualisation environments, while supporting multiple protocols
and standards used in computer networks.

The ovs_stats plugin collects statistics of OVS connected interfaces.
This plugin uses OVSDB management protocol (RFC7047) monitor mechanism
to get statistics from OVSDB.

    parameter_defaults:
        CollectdExtraPlugins:
          - ovs_stats
        ExtraConfig:
            collectd::plugin::ovs_stats::socket: '/run/openvswitch/db.sock'

### pmu

The intel_pmu plugin collects information provided by Linux perf
interface which provides rich generalized abstractions over hardware
specific capabilities. All events are reported on a per core basis.

Performance counters are CPU hardware registers that count hardware
events such as instructions executed, cache-misses suffered, or branches
mispredicted. They form a basis for profiling applications to trace
dynamic control flow and identify hotspots.

### processes

### sysevent

The sysevent plugin monitors rsyslog messages, filters for log
messages and creates events when a defined filter was triggered.

### virt

This plugin allows CPU, disk, network load and other metrics to be
collected for virtualized guests on the machine.

    parameter_defaults:
        CollectdExtraPlugins:
          - virt
        ExtraConfig:
            collectd::plugin::virt:hostname_format: "hostname"
            collectd::plugin::virt:extra_stats: "cpu_util disk vcpu"

## Output plugins

### amqp1

the plugin writes values to an amqp1 message bus, such as QPID.

    parameter_defaults:
        CollectdExtraPlugins:
          - amqp1
        ExtraConfig:
            collectd::plugin::amqp1::send_queue_limit: 50

### write_http

This output plugin submits values to an HTTP
server using POST requests and encoding metrics
with JSON or using the PUTVAL command.

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

### write_kafka

This write plugin sends values to a Kafka topic.

    parameter_defaults:
        CollectdExtraPlugins:
           - write_kafka
        ExtraConfig:
          collectd::plugin::write_kafka::kafka_hosts:
            - nodeA
            - nodeB
          collectd::plugin::write_kafka::topics:
            some_events:
              format: JSON

## Miscellaneus plugins

### unix

