#Title: "Santa's Christmas Dancer2 Web App - Naughty & Nice List Manager"

Ho, ho, ho! In this hilarious Christmas-themed Dancer2 web app tutorial, we'll help Santa manage his Naughty & Nice list. This time, we're using Perl's Dancer2 framework, but Santa's Christmas spirit is universal. Let's dive in and create Santa's very own web app!


## todo.pl
```
#!/usr/bin/env perl

use Dancer2;
set template => 'mustache';

# Initialize Santa's Naughty & Nice List
my $list = { list => [] };

get '/' => sub {
    send_file '/index.html';
};

any '/delete' => sub {
    my $q = request->params;
    my $index = 0;

    # Find the naughty or nice kid to remove
    $index++ until $list->{list}[$index]{task} eq $q->{task};
    splice(@{$list->{list}}, $index, 1);

    # Display the updated list
    template 'list' => $list;
};

any '/add' => sub {
    my $q = request->params;

    # Add a new kid to the list
    push @{$list->{list}}, $q;

    # Display the updated list
    template 'list' => $list;
};

any '/list' => sub {
    # Display the current list
    template 'list' => $list;
};

start;
```

Here's what Santa's Christmas Dancer2 web app does:

1. We set up our Dancer2 app with Mustache templates.
2. Santa initializes his Naughty & Nice List as an empty array of tasks.
3. When you visit the root URL /, it serves an index.html file. Make sure to create this HTML file for a nice, festive interface.
4. To delete a naughty or nice kid, we look for the kid's task in the list and remove them. Then, we display the updated list using the 'list' template.
5. To add a kid to the list, we take the kid's name from the request parameters, push them onto the list, and display the updated list using the 'list' template.
6. The /list route simply displays the current Naughty & Nice List.

Now, Santa can keep a digital record of all the good and naughty children, and you can help him manage it with this fun Dancer2 web app. Merry Christmas and happy coding! 🎅🎄🌟

## public/index.html
```
<!DOCTYPE html>
<html>
	<head>
		<title>TODO app</title>
		<!-- Include the htmx.js library for AJAX interactions -->
		<script src="https://unpkg.com/htmx.org@1.9.6"></script>
		<!-- Include a stylesheet (Water.css in dark mode) for styling -->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/dark.css">
	</head>
	<body>
		<!-- Create a form for adding tasks -->
		<form hx-post="/add" hx-target="#list" hx-on::after-request="this.reset()">
	  		<fieldset>
				<!-- Input field for entering a task -->
				<input type="text" name="task" placeholder="enter task" />
				<!-- Button to submit the task -->
				<button type="submit">Add Task</button>
	  		</fieldset>
		</form>
  		<fieldset>
			<!-- Display the list of tasks here using AJAX -->
			<div id="list" hx-get="/list" hx-trigger="load"></div>
  		</fieldset>
	</body>
</html>
```

This HTML code provides a simple web interface to add and view tasks. When a user adds a task, it's sent to the server using htmx via the hx-post attribute, and the response updates the task list on the page. Santa can now manage his Naughty & Nice list with a modern touch. Merry Christmas and happy coding! 🎅🎄🌟

The provided template uses htmx, a library for building modern web applications with HTML, to create a list of tasks with some interactive behavior. Let's break down the template step by step:

## views/list.mustache
```
<ul>
    {{#list}} <!-- This is a loop that iterates through the 'list' array -->
        <li hx-post="/delete" hx-target="#list" hx-vals='{"task":"{{task}}"}'>{{task}}</li>
        <!-- For each item in 'list', create an <li> element -->
        <!-- 'hx-post' specifies an HTTP POST request when this <li> element is clicked -->
        <!-- 'hx-target' designates where the response will be placed (in this case, back into the list) -->
        <!-- 'hx-vals' defines the data to send with the POST request -->
        <!-- The data consists of a key "task" with the value being the task name from the list -->
        <!-- The {{task}} within the hx-vals is a placeholder for the task name from the loop -->
        {{task}}
        <!-- Display the task name within the <li> element -->
    {{/list}}
</ul>
```
Here's how this template works:

1. `<ul>`: This creates an unordered list where each task will be represented as a list item `<li>`
2. `{{#list}}`: and `{{/list}}`: These tags denote a loop that iterates through the 'list' array. For each item in the 'list', it performs the following operations.
3. `<li>`: This creates an `<li>` element for each task in the 'list'
4. hx-post="/delete": When an `<li>` element is clicked, htmx sends an HTTP POST request to the URL specified in the hx-post attribute. In this case, it's /delete, indicating a task deletion action.
5. hx-target="#list": This attribute specifies where the response of the HTTP POST request should be placed. In this example, it replaces the content of the element with the ID "list," effectively updating the list after a task is deleted.
6. hx-vals='{"task":"{{task}}"}': This attribute defines the data to send with the POST request. It includes a key "task" with a value equal to the task name. The {{task}} is a placeholder that gets replaced with the actual task name from the loop during execution.
7. {{task}}: Inside the `<li>` element, this placeholder displays the task name from the loop in the list item.

In summary, this template generates a list of tasks, and each task has a delete button. When a delete button is clicked, htmx sends a POST request to the server to delete the corresponding task and updates the list without requiring a full page refresh.




