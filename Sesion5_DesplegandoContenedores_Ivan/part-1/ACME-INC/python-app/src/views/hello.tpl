<!DOCTYPE html>
<html>
<head>
    <!--Import Google Icon Font-->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!--Import materialize.css-->
    <link type="text/css" rel="stylesheet" href="static/css/materialize.min.css"  media="screen,projection"/>

    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
</head>

<body>
        <div class = "card-panel teal lighten-2"><h3>Devops Bootcamp</h3></div>
    <div class="row">
        <div class="col s12">
            %if name == 'World':
            <h1>Hello {{name}}!</h1>
            <p>This is a test.</p>
            %else:
            <h1>Hello {{name.title()}}!</h1>
            <p>How are you?</p>
            %end
        </div>
    </div>
    <!--JavaScript at end of body for optimized loading-->
    <script type="text/javascript" src="static/js/materialize.min.js"></script>
</body>
</html>
