<?php
# Screenly OSE Monitoring Addon
# Created by didiatworkz
# Addon: Raspberry API

$_VERSION = '0.2';


  function zeroFilter($var){
    return ($var !== NULL && $var !== FALSE && $var !== '');
  }

  function _uptime(){
      $data               = array();
      $data['pretty']     = exec('uptime -p');
      $since              = exec('uptime -s');
      $data['full']       = exec('uptime');
      $seconds            = strtotime($since);
      $data['since']      = $since;
      $data['inseconds']  = time() - $seconds;
      return $data;
  }

  function _cpuusage(){
      $output = 100 - shell_exec("vmstat | tail -1 | awk '{print $15}'");
      return $output;
  }

  function _cpuInfo(){
      $data   = array();
      $output = shell_exec('lscpu');
      $output = explode("\n", $output);
      foreach ($output as $item)
      {
          $parts  = explode(":", $item);
          $key    = preg_replace('/\s+/', '', $parts['0']);
          $value  = preg_replace('/\s+/', '', $parts['1']);
          if($key != '') $data[$key] = $value;
      }
      return $data;
  }

  function _os(){
      $data                   = array();
      $data['all']            = exec('uname -a');
      $data['kernel_name']    = exec('uname -s');
      $data['kernel_version'] = exec('uname -v');
      $data['kernel_release'] = exec('uname -r');
      $data['hostname']       = exec('uname -n');
      $data['machine']        = exec('uname -m');
      $data['processor']      = exec('uname -p');
      $data['platform']       = exec('uname -i');
      $data['os']             = exec('uname -o');
      return $data;
  }

  function _diskSpace($path){
      $data               = array();
      $bytes              = disk_free_space($path);
      $bytesT             = disk_total_space($path);
      $si_prefix          = array( 'B', 'KB', 'MB', 'GB', 'TB', 'EB', 'ZB', 'YB' );
      $base               = 1024;
      $class              = min((int)log($bytes , $base) , count($si_prefix) - 1);
      $disk_free          = sprintf('%1.2f' , $bytes / pow($base,$class));
      $classT             = min((int)log($bytesT , $base) , count($si_prefix) - 1);
      $disk_total         = sprintf('%1.2f' , $bytesT / pow($base,$classT));
      $disk_used          = $disk_total - $disk_free;
      $disk_percentage    = round($disk_used / $disk_total * 100);
      $data['total']      = strval($disk_total.' '.$si_prefix[$class]);
      $data['used']       = strval($disk_used.' '.$si_prefix[$class]);
      $data['free']       = strval($disk_free.' '.$si_prefix[$class]);
      $data['percentage'] = strval($disk_percentage.'%');
      return $data;
  }

  function _memory(){
      $data               = array();
      $out                = shell_exec('free -m');
  	  preg_match_all('/\s+([0-9]+)/', $out, $matches);
  	  list($memory_total, $memory_used, $memory_free, $memory_shared, $memory_buffers, $memory_cached) = $matches[1];
      $memory_percentage  = round(($memory_used) / $memory_total * 100);
      $data['total']      = $memory_total;
      $data['used']       = $memory_used;
      $data['free']       = $memory_free;
      $data['percentage'] = strval($memory_percentage.'%');
      $data['shared']     = $memory_shared;
      $data['buffers']    = $memory_buffers;
      $data['cached']     = $memory_cached;
      return $data;
  }

  function _temp(){
      $data               = array();
      $data['output']     = exec('cat /sys/class/thermal/thermal_zone*/temp');
      $data['celsius']    = strval(round($data['output'] / 1000, 1));
      return $data;
  }

  function _diskFree(){
      $data           = array();
      $output         = shell_exec("df -Th");
      $output         = explode("\n", $output);
      $headlines      = array_values(array_map('trim',array_filter(explode(' ',$output['0']))));
      $filesystem     = $headlines['0'];
      $type           = $headlines['1'];
      $k              = $headlines['2'];
      $used           = $headlines['3'];
      $available      = $headlines['4'];
      $use            = $headlines['5'];
      $mounted        = $headlines['6'].' '.$headlines['7'];
      $values         = array_values(array_map('trim',array_filter(explode(' ',$output["1"]))));
      $n              = 0;
      for($i = 0; $i < count($output); $i++){
          if($output[$i] == NULL OR $i == 0) continue;
          $values                 = array_values(array_map('trim',array_filter(explode(' ',$output[$i]),zeroFilter)));
          $data[$n][$filesystem]  = $values['0'];
          $data[$n][$type]        = $values['1'];
          $data[$n][$k]           = $values['2'];
          $data[$n][$used]        = $values['3'];
          $data[$n][$available]   = $values['4'];
          $data[$n][$use]         = $values['5'];
          $data[$n][$mounted]     = $values['6'];
          $n++;
      }
      $data['count']  = $n;
      return $data;
  }

  $method = $_SERVER['REQUEST_METHOD'];
  $parameter = $_GET['get'];

  if($method == 'GET' AND isset($parameter)){
      switch ($parameter) {
        case 'version':
          $data['version']    = $_VERSION;
          break;
        case 'uptime':
          $data['uptime']     = _uptime();
          break;
        case 'cpuusage':
          $data['cpuusage']   = _cpuusage();
          break;
        case 'cpuinfo':
          $data['cpuinfo']    = _cpuInfo();
          break;
        case 'os':
          $data['os']         = _os();
          break;
        case 'memory':
          $data['memory']     = _memory();
          break;
        case 'disk_free':
          $data['disks']      = _diskFree();
          break;
        case 'temp':
          $data['temp']       = _temp();
          break;
        case 'disk':
          $data['sd']         = _diskSpace('/');
          $data['screenshot'] = _diskSpace('/var/www/html/addon/screen');
          break;
        case 'info':
          $data['os']         = _os();
          $data['temp']       = _temp();
          $data['uptime']     = _uptime();
          $data['cpuinfo']    = _cpuInfo();
          $data['cpuusage']   = _cpuusage();
          $data['memory']     = _memory();
          $data['sd']         = _diskSpace('/');
          $data['screenshot'] = _diskSpace('/var/www/html/addon/screen');
          $data['disks']      = _diskFree();
          $data['version']    = $_VERSION;
          break;
      }
  header('Content-Type: application/json');
  echo json_encode($data);
  }
  else die('Access denied!');
?>
