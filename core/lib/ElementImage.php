<?php

class ElementImage extends StepElement
{
	protected function init()
	{

	}

	public function validate(&$data)
	{
		return true;
	}

	protected function prepareRender()
	{
    $images = array();

    foreach ($this->arguments as $key => $image)
		{
      $images[$key] = $this->properties['mediaurl'] . $image;
		}

    $this->tpl->set('images', $images);
	}
}
