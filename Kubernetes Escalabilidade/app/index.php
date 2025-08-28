<?php
// Ex: http://SEU_HOST/?work=400000
$work = isset($_GET['work']) ? intval($_GET['work']) : 0;

function burn($n) {
  $x = 0.0;
  for ($i = 1; $i <= $n; $i++) {
    // operações “caras” para CPU
    $x += sqrt($i) + sin($i) + cos($i);
  }
  return $x;
}

$start = microtime(true);
$val = burn($work);
$elapsed = round((microtime(true)-$start)*1000, 2);

header('Content-Type: text/plain');
echo "OK | work=$work | elapsed_ms=$elapsed | val=$val\n";
