#! /usr/bin/node

const { exec } = require("child_process");
const args = require("args-parser")(process.argv)

function average(nums) {
  return nums.reduce((a, b) => (a + b)) / nums.length;
}

function login() {
    exec(`xo-cli system.getVersion`, (error) => {
      if (error) {
        exec(`xo-cli --register ${args.url} ${args.username} ${args.password}`, (l_error, l_stdout, l_stderr) => {
          if (l_error) {
            console.log(`error: ${l_error.message}`)
          }
          if (l_stderr) {
            console.log(`stderr: ${l_stderr}`)
          }
        })
      }
    })
}

function hostDiscovery() {
  exec("xo-cli --list-objects type=host", (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`)
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`)
      return;
    }
    const hosts = JSON.parse(stdout)

    const host_list = []

    for (let i in hosts) {
      host_list.push({
        "{#UUID}": hosts[i].uuid,
        "{#HOSTNAME}": hosts[i].hostname,
        "{#POWERSTATE}": hosts[i].power_state,
        "{#CORES}": hosts[i].CPUs.cpu_count,
      })
    }
    return console.log(JSON.stringify({data: host_list}, null, 2))
  })
}

function vmDiscovery () {
  exec("xo-cli --list-objects type=VM", (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`)
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`)
      return;
    }
    const vms = JSON.parse(stdout)

    const vm_list = []

    for (let i in vms) {
      vm_list.push({
        "{#UUID}": vms[i].uuid,
        "{#HOSTNAME}": vms[i].name_label,
        "{#POWERSTATE}": vms[i].power_state
      })
    }
    return console.log(JSON.stringify({data: vm_list},null,2))
  })
}

function storageDiscovery () {
  exec("xo-cli --list-objects type=SR", (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`)
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`)
      return;
    }
    const disks = JSON.parse(stdout)

    const vm_list = []

    for (let i in disks) {
      vm_list.push({
        "{#UUID}": disks[i].uuid,
        "{#POOLNAME}": disks[i].name_label,
        "{#SIZE}": disks[i].size,
        "{#USAGE}": disks[i].usage,
  "{#SRTYPE}": disks[i].SR_type,
  "{#SRPHYSICAL_USAGE}": disks[i].physical_usage,
      })
    }
    return console.log(JSON.stringify({data: vm_list},null,2))
  })
}



function hostCollect () {
  exec(`xo-cli --list-objects type=host uuid=${args.host}`, (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`)
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`)
      return;
    }

    const hosts = JSON.parse(stdout)

    for (let i in hosts) {
      exec(`xo-cli host.stats host=${hosts[i].uuid} > /tmp/${hosts[i].uuid}.json`, (h_error, h_stdout, h_stderr) => {
        if (h_error) {
          console.log(`error: ${h_error.message}`)
          return;
        }
        if (h_stderr) {
          console.log(`stderr: ${h_stderr}`)
          return;
        }

        const stats = require(`/tmp/${hosts[i].uuid}.json`).stats;
        let cpu_list = []
        let cpu_avg = []

        for (let j in stats.cpus) {
          let core = {}
          core["CORE " + j] = stats.cpus[j][stats.cpus[j].length - 1]
          cpu_avg.push(stats.cpus[j][stats.cpus[j].length - 1])
          cpu_list.push(core)
        }

        const result = {
          uuid: hosts[i].uuid,
          address: hosts[i].address,
          cpu_avg: average(cpu_avg),
          cpu: {
            speed: hosts[i].CPUs.speed,
            modelName: hosts[i].CPUs.modelName,
            cores: hosts[i].CPUs.cores,
            sockets: hosts[i].CPUs.sockets
          },
          cores: cpu_list,
          memory: {
            usage: hosts[i].memory.usage,
            size:hosts[i].memory.size,
          },
          load: stats.load[stats.load.length - 1]
        }
        console.log(JSON.stringify(result, null, 2))
      })
    }
  })
}

function vmCollect () {
  exec(`xo-cli --list-objects type=VM uuid=${args.vm}`, (error, stdout, stderr) => {
    if (error) {
      return console.log(`error: ${error.message}`)
    }
    if (stderr) {
      return console.log(`stderr: ${stderr}`)
    }
    const vms = JSON.parse(stdout)

    for (let i in vms) {
      exec(`xo-cli vm.stats vm=${vms[i].uuid}`, (v_error, v_stdout, v_stderr) => {
        if (v_error) {
          return console.log(`error: ${v_error.message}`)
        }
        if (v_stderr) {
          return console.log(`stderr: ${v_stderr}`)
        }

        const stats = JSON.parse(v_stdout).stats
        const cpu_list = []
        const cpu_avg = []

        for (let j in stats.cpus) {
          let core = {}
          core["CORE " +  j] = stats.cpus[j][stats.cpus[j].length - 1]
          cpu_list.push(core)
          cpu_avg.push(stats.cpus[j][stats.cpus[j].length - 1])
        }

        const interface_list = []

        for (let j in stats.vifs.tx) {
          let int = {}
          int["Inteface " + j] = {
            rx: average(stats.vifs.rx[j].splice(stats.vifs.rx[j].length - 13,stats.vifs.rx[j].length - 1)),
            tx: average(stats.vifs.tx[j].splice(stats.vifs.tx[j].length - 13,stats.vifs.tx[j].length - 1))
          }
          interface_list.push(int)
        }


        const result = {
          uuid: args.uuid,
          power_state: vms[i].power_state,
          cpu_avg: average(cpu_avg),
          cpu: {
            number: vms[i].CPUs.number,
          },
          cores: cpu_list,
          memory: {
            free: stats.memoryFree ? stats.memoryFree[stats.memoryFree.length -1] : vms[i].memory.size,
            size: vms[i].memory.size
          },
          network: interface_list
        }
        return console.log(JSON.stringify(result, null, 2))
      })
    }
  })
}

function storageCollect () {
  exec("xo-cli --list-objects type=SR", (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`)
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`)
      return;
    }
    const disks = JSON.parse(stdout)

    const disk_list = []

    for (let i in disks) {
      disk_list.push({
        uuid: disks[i].uuid,
        poolname: disks[i].name_label,
        size: disks[i].size,
        usage: disks[i].usage,
  physical_usage: disks[i].physical_usage
      })
    }
    return console.log(JSON.stringify(disk_list,null,2))
  })
}


if (args && args.username && args.password && args.url) {
  login()
} else {
  console.log("\nUsage: zabbix_xo.js username=[email] password=[senha] url=[xen orchestra url] OPTIONS\n\nOPTIONS:\ndiscovery=host\ndiscovery=vm\n\ncollect=host host=[host uuid]\ncollect=vm vm=[vm uuid]\n")
}

if (args.discovery && args.discovery == 'host') {
  hostDiscovery()
}

if (args.discovery && args.discovery == 'vm') {
  vmDiscovery()
}

if (args.discovery && args.discovery == 'disk') {
  storageDiscovery()
}

if (args.collect && args.collect == 'host' && args.host) {
  hostCollect()
}

if (args.collect && args.collect == 'vm' && args.vm) {
  vmCollect()
}

if (args.collect && args.collect == 'disk') {
  storageCollect()
}
