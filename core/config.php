<?php

$securitySalt = 'QualityCrowd2-7078e430';

return array(

'timezone' => 'Europe/Berlin',

'securitySalt' => $securitySalt,

'adminUsers' => array(
	'admin' => sha1('qualitycrowd_2021' . $securitySalt)
),

'filePermissions' => 0666,
'dirPermissions' => 0777,

);
