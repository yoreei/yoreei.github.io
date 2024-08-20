+++
title = "Comparison Feature for Sanctuary Raytracer"
date = "2024-08-19"
draft = false
categories = ["Computer Graphics"]

#[cover]
#image = "cover.jpg"
#alt = "sanctuary ray tracer compare post cover"
#caption = ""
#relative = true
+++

# Comparison Feature for Sanctuary Raytracer

I am currently fixing a bug with the KDTree implementation in my raytracer, which makes some triangles disappear under certain angles. I like these hard to spot bugs to stay fixed, so I decided to automate the process of finding them and inspecting them. When run in "comparison" mode, "Sanctuary" compares its output with a known good render, residing in a "compare" folder. If a known good render of the scene exists, the images are compared and an image diff is generated.

You can see on the video, some triangles on the leg of the dragon are missing, when looked from this angle. This bug was easily missed during the initial development of the KDTree, because most angles don't suffer from this. Now, I can leave the ray tracer running while I sleep and come back the next morning to inspect if I've introduced any regressions the previous day.

Next step is to actually fix the bug. I'll post a benchmark of the KDTree once done.

<video width="640" height="360" controls>
  <source src="compare.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>