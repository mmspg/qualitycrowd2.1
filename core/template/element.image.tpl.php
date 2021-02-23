<p style="text-align:center">
<?php foreach ($images as $image): ?>
  <img
    srcset="
      <?= $image ?> 1x,
      "
    src="<?= $image ?>" alt="">
<?php endforeach; ?>
</p>
