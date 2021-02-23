
<?php

if($_POST['command']=='registerUserID'){
  $workerPrefix="expert";

  if(!empty($_POST['workerPrefix'])){
    $workerPrefix = $_POST['workerPrefix'];
  }

  $devPixRatio = $_POST['devPixRatio'];
  $screenRes = $_POST['screenRes'];
  $availRes = $_POST['availRes'];
  $windowRes = $_POST['windowRes'];

  // Read batches list from
  $filename = "../batches/batches_list.csv";
  $file = fopen($filename,"r");
  $contents = fread($file, filesize($filename));
  fclose($file);
  $lines = explode("\n", $contents,-1);
  $batches = array();
  foreach ($lines as $key => $line) {
    $cells = explode(",",$line);
    $batches[$cells[0]] = $cells[1];
  }
  $batch_count = count($batches);

  $filename = "subject_ids.csv";
  $file = fopen($filename,"a+");
  if (flock($file,LOCK_EX)) { // exclusive lock
    $id = 1;
    // Read the last id
    fseek($file, 0);
    $contents = fread($file, filesize($filename));
    $lines = explode("\n", $contents,-1);
    $cells = explode(",",end($lines));
    $last_id = $cells[0];
    if($last_id > 0){
      $id = $last_id + 1;
    }
    $data = [
      $id,
      $batches[($id-1)%$batch_count+1],
      $workerPrefix . sprintf("%05d",$id),
      time(),
      $devPixRatio,
      $screenRes,
      $availRes,
      $windowRes,
      $_SERVER['REMOTE_ADDR'],
    ];
    $dataline = implode(",",$data);
    // Write current id to the file
    fseek($file, 0, SEEK_END);
    fwrite($file,$dataline."\n");
    fflush($file);

    flock($file,LOCK_UN); // release lock
  } else {
    echo "Error locking file!\n";
  }
  fclose($file);

  echo "{$data[1]}/{$data[2]}";

}

// echo $dataline."\n";
// echo "last_id = ".$last_id."\n\n";

?>
