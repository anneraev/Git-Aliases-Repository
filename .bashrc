alias gs="git status"

aliases () {
  code ~/.bashrc
}

initalias () {
  source ~/.bashrc
}

gituninit () {
  rm -rf .git
}

##cd quickly into game dev folders
gamedev () {
  cd
  cd documents
  cd MVprojects
}

##cd quickly into directory containing dev libraries sourced from the web.
gamedevlibraries () {
  cd
  cd projectsG
}

serverstart () {
  json-server -p "$1" -w "$2".json
}


#accepts name of directory
localstart () {
  toplevel "$1"
  cd src
  http-server -o
}

#accepts name of directory
gruntstart () {
  toplevel "$1"
  cd src/lib
  grunt
}

#accepts directory name
openproject () {
  cd "$1"
  code .
}

openpworkspace () {
  cd
  cd workspace
}

#accepts project file name
rootopenproject () {
  openpworkspace
  openproject "$1"
}

# Accepts new directory file path to create.
directory () {
  mkdir "$1"
  cd "$1"
}

#accepts name of directory to cd into the top level of.
toplevel () {
  cd
  cd
  cd workspace
  cd "$1"
}



# Accepts git origin repository URL.
gitinit () {
  git init
  git remote add origin "$1"
}

firstpush () {
  git commit -m "first commit"
  git push -u origin master
}

#accepts directory name.
createBrowserifyProject () {
  cd $(git rev-parse --show-toplevel)
  cd
  cd workspace
  directory "$1"
  su-grunt-browserify
  cd src/lib
  npm install
  cd ../../
  code .
}

#First item is the directory name, second is the URL of the github repo.
createGitProject () {
  createProject "$1"
  gitinit "$2"
}

su-grunt-browserify () {
  touch README.md
  touch .gitignore
  echo 'node_modules
public/*.js
bower_components
__pycache__
*.pyc
bin
obj
*.db
*.sqlite3
.vscode
dist
' >> .gitignore
  echo '{
    "env": {
        "browser": true,
        "commonjs": true,
        "node": true
    },
    "parserOptions": {
        "ecmaFeatures": {
            "jsx": true
        },
        "ecmaVersion": 8,
        "sourceType": "module"
    },
    "rules": {
        "no-const-assign": "warn",
        "no-this-before-super": "warn",
        "no-undef": "warn",
        "no-unreachable": "warn",
        "no-unused-vars": "warn",
        "constructor-super": "warn",
        "valid-typeof": "warn",
        "quotes": ["error", "double"],
        "no-trailing-spaces": 2
    },
    "globals": {
        "$": true
    }
}' >> .eslintrc
  mkdir api
  cd api
  touch database.json
  cd ..
  mkdir public
  cd public
    echo '<!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="./styles/main.css">
    <title>Application Title</title>
  </head>
  <body>

    <div id="display-container"></div>

    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script src="./bundle.js"></script>
  </body>
  </html>' >> index.html
  mkdir styles
  touch styles/main.css
  cd ..
  mkdir src
  cd src
  mkdir scripts
  cd scripts
  touch main.js
  touch eventManager.js
  echo 'import formBuilder from "./formBuilder";
import domManager from "./domManager";

// To call a specific input element, use this template(where "key" is the key of the input originally defined in the keysArray):

// referenceVariableContainingObject.key

// To get the label of that input:

// referenceVariableContainingObject.keyLabel

// To get the container around the label and input:

// referenceVariableContainingObject.keyContainer.

//To get a specific option from a select element:

//referenceVariableContainingObject.keyid (where id is the numbered position of the option in the list of options, starting with 0).

// Each form object has methods for adding new elements to the form. Each has specific data that needs to be passed, so examine the structure of the object constructor defined in formObject.js. Of note, however, is the "target" attribute which defines which element the new element will be appended to.

const formObject = function (wholeForm, elementArray, submitButton) {
    //dynamically builds a key for the input element, its container, and its label to store a reference to those elements for easy retrieval.
    this.createKeys = function(element, key, container, id) {
        let elementKey
        if (id) {
            elementKey = `${key}${id}`
        } else {
            elementKey = key
        }
        this[elementKey] = element;
        const containerKey = `${elementKey}Container`;
        const labelKey = `${elementKey}Label`;
        this[containerKey] = container
        this[labelKey] = this[containerKey].firstChild
    };
    this.form = wholeForm;
    this.elements = elementArray;
    this.submitButton = submitButton;
    this.referenceFormElements = function () {
        //array of just the inputs for easy access by the script.
        const inputsArray = [];
        //all the various form inputs are indentified by their key value (the same as the key value that was originall passed to them when the formBuilder function called--they keys stored in the keysArray variable) The keys are also used to identify their label and container. Calling them in this way allows easy access to manipulate the attributes of these elements.
        this.elements.forEach(element => {
            const id = element.id;
            const idArray = id.split("--");
            const key = idArray[3];
            const container = element.parentNode;
            let optionId;
            if (element.tagName === "option") {
                optionId = idArray[4];
            } else {
                optionId = undefined;
            }
            this.createKeys(element, key, container, optionId);
            if (element.tagName.match(/^(INPUT|SELECT|TEXTAREA)$/)) {
                console.log("input element", element.tagName);
                inputsArray.push(element);
            }
        })
        this.inputs = inputsArray
    };
    //these methods allow the user to easily add new elements to the form object, as well as the DOM.
    this.newHeader = function (tag, id, key, target) {
        const header = formBuilder.buildHeader(tag, id, key);
        target.appendChild(header);
        this.createKeys(header, key, target);

    }
    this.newTextArea = function (key, id, target) {
        const textarea = formBuilder.buildTextArea(key, id);
        target.appendChild(textarea);
        this.createKeys(textarea, key, target);
    };
    this.newdropDown = function (key, id, value, optionsArray, target) {
        const dropDown = formBuilder.buildDropdown(key, id, value, optionsArray)
        target.appendChild(dropDown);
        this.createKeys(dropDown, key, target);

    };
    this.newRadio = function (option, optionIndex, id, key, target) {
        const radio = formBuilder.buildOption(option, optionIndex, "radio", id, key)
        target.appendChild(radio);
        this.createKeys(radio, key, target);

    };
    this.newCheckbox = function (option, optionIndex, id, key, target) {
        const checkbox = formBuilder.buildOption(option, optionIndex, "checkbox", id, key)
        target.appendChild(checkbox);
        this.createKeys(checkbox, key, target);

    };
    this.newInput = function (type, key, id, value, target) {
        const input = formBuilder.buildInput(type, key, id, value)
        target.appendChild(input);
        this.createKeys(input, key, target);

    };
    this.newButton = function (id, name, targetElement) {
        const button = formBuilder.buildButton(id, name)
        targetElement.appendChild(button);
        this.createKeys(button, name, targetElement);
    };
    //remove element and everything inside it.
    this.removeElement = function (element) {
        domManager.removeElement(element);
    }
}

export default {
    createFormObject: function (form, elementArray, submitButton) {
        const newFormObject = new formObject(form, elementArray, submitButton);
        return newFormObject;
    }
}
' >> formObjectManager.js
  echo 'import htmlBuilder from "./htmlBuilder"
import formObjectManager from "./formObjectManager"
//will be passed to the object that contains all the values of this form.
let elementsArray = [];

//This creates an array of the created elements, iterate through them, dynamically build key/value pairs that refer to the element, store the object. That way, any of the forms elements can be easily referred to. See the comments in formObjectManager.js for more information on how to call specific elements.

//call function:
// formBuilder.buildForm: function (wrapperType, title, keysArray, valuesArray, typesArray, id, arrayOptionsArray)

// The following must be passed to the form builder call function:

// wrappperType = type of wrapper that the form will be displayed in (div, fieldset, ect.)

// let title = "Form Builder Function Test"

// let id = id for form

// let wrapperType = type of wrapper for form

// let keysArray = array of keys associated with each input in the form.

// let valuesArray = array of values associated with each input in the form.

// let typesArray = array of types of inputs to create.

// let arrayOptionsArray = array of arrays containing options. Ideally, these should come from an API database containing those options, and should arrive as an array in the order they appear in the databese. That array should be pushed to this array to create an array of arrays.

// One of each much be defined for EVERY input. If one of the above are not valid, enter "undefined" for that entry.

//ID style guide:
//Whole Form ("form"--id)
//wrapper for each item ("wrapper"--id--type)
//label for each item ("label"--id--type--key--optionId(if multiple))
//field item ("field"--id--type--key--optionId(if multiple))

//Title - defined title.
// id - id of data object.
// type - type of input
// key - name of item in data.

//A reference to the object needs to be made inside the buttons event listener. Makes it easy to access.

//One can easily set up a form to be created by using formBuilder.(setWrapper(element type), set title(title string), addKey(key string), addValue(value string), addType(input type string), setId(id integer), addOptions(array of options)). Then, one call the form with formBuilder.createForm (no arguments needed). Store the returned form in a variable and access the form with nameOfFormVariable[0] and the object with nameOfFormVariable[1].

let wrapperType
let title
let keysArray = []
let valuesArray = []
let typesArray = []
let id
let arrayOptionsArray = []

export default {
    //Title of form, Array of original keys, array of original values, array of types of fields, id from dataset.
    buildForm: function (wrapperType, title, keysArray, valuesArray, typesArray, id, arrayOptionsArray) {
        //(elementType, elementId, elementTextContent, elementValue)
        //create form.
        const form = htmlBuilder.elementBuilder(wrapperType, `${title}--${id}`)
        if (wrapperType === "fieldset") {
            const legend = this.buildLegend(title, id);
            form.appendChild(legend);
        }
        //loops through keys and builds a form and label from the passed data.
        for (let i = 0; i < keysArray.length; i += 1) {
            //container for the label/form pairs.
            const type = typesArray[i];
            const key = keysArray[i];
            const optionsArray = arrayOptionsArray[i];
            const value = valuesArray[i];
            //label and form
            if (type === "radio" || type === "checkbox") {
                const heading = this.buildHeader("h5", id, key)
                form.appendChild(heading);
            };
            //specify type
            if (type === "textarea") {
                let textArea = this.buildTextArea(key, id); //?
                form.appendChild(textArea);
            } else if (type === "select") {
                const dropDown = this.buildDropdown(type, key, id, value, optionsArray);
                form.appendChild(dropDown);
                //all other input types.
            } else {
                //if type is checkbox or radio button.
                if (type === "radio" || type === "checkbox") {
                    optionsArray.forEach(option => {
                        let optionIndex = optionsArray.indexOf(option);
                        let newItem = this.buildOption(option, optionIndex, type, id, key) //?
                        form.appendChild(newItem);
                    })
                } else {
                    const field = this.buildInput(type, key, id, value)
                    form.appendChild(field);
                }
            }
        }
        //append the elements to the form, create form object, and return an array containing the form itself for appending, as well as a reference to the form object. The form object contains methods for easy reference to any of the forms elements, as well as functions for adding elements.
        const submitButton = this.buildButton(id, "Submit");
        form.appendChild(submitButton);
        console.log(form);
        const newFormObject = formObjectManager.createFormObject(form, elementsArray, submitButton);
        newFormObject.referenceFormElements();
        const formArray = []
        formArray.push(form);
        formArray.push(newFormObject);
        return formArray;
    },
    buildHeader: function (number, id, key) {
        //number is the header type. (h1, h2, ect.)
        const header = htmlBuilder.elementBuilder(`h${number}`, `label--${id}--h${number}--${key}`, `${key}`);
        elementsArray.push(header);
        return header;
    },
    buildLabel: function (key, id, type) {
        const label = htmlBuilder.elementBuilder("label", `label--${id}--${type}--${key}`, `${key}`, undefined)
        elementsArray.push(label);
        return label
    },
    buildLegend: function (title, id) {
        const legend = htmlBuilder.elementBuilder("legend", `legend--${title}--${id}--legend`, `${title}:`);
        elementsArray.push(legend);
        return legend;
    },
    buildTextArea: function (key, id) {
        const label = this.buildLabel(key, id, "textarea")
        const div = htmlBuilder.elementBuilder("div", `wrapper--${id}--textarea`)
        const textArea = htmlBuilder.elementBuilder("textarea", `field--${id}--textarea--${key}`);
        div.appendChild(label);
        div.appendChild(textArea);
        elementsArray.push(textArea);
        return div;
    },
    buildDropdown: function (key, id, value, optionsArray) {
        const label = this.buildLabel(key, id, "select")
        const div = htmlBuilder.elementBuilder("div", `wrapper--${id}--dropdown`)
        const dropdown = htmlBuilder.elementBuilder("select", `field--${id}--"select"--${key}`, undefined, `${value}`) //?
        //build out options for the select input type. The value is alwas an integer representing the Id of the item in the dataset.
        const type = "select"
        optionsArray.forEach(option => {
            const optionIndex = optionsArray.indexOf(option);
            const addedOption = this.buildOption(option, optionIndex, type, id, key);
            dropdown.appendChild(addedOption);
        })
        div.appendChild(label);
        div.appendChild(dropdown);
        elementsArray.push(dropdown);
        return div;
    },
    buildOption: function (option, optionIndex, type, id, key) {
        let optionValue
        let inputType
        const optionNum = optionIndex + 1
        if (type === "select" || type === "dropdown" || type === "option") {
            optionValue = optionNum;
            inputType = "option"
        } else {
            optionValue = option;
            inputType = "input";
        }
        const newOption = htmlBuilder.elementBuilder(`${inputType}`, `field--${id}--${type}--${key}--${optionNum}`, `${option}`, `${optionValue}`)
        elementsArray.push(newOption);
        if (inputType !== "option") {
            const label = htmlBuilder.elementBuilder("label", `label--${id}--${type}--${key}--${optionNum}`, `${option}`);
            if (type === "radio") {
                newOption.setAttribute("name", `${key}`);
            }
            newOption.setAttribute("type", `${type}`);
            const optionDiv = htmlBuilder.elementBuilder("div", `divOption--${id}--${type}--${key}--${optionNum}`)
            optionDiv.appendChild(label);
            optionDiv.appendChild(newOption);
            return optionDiv;
        } else {
            return newOption;
        }
    },
    buildInput: function (type, key, id, value) {
        const label = this.buildLabel(key, id, type)
        const div = htmlBuilder.elementBuilder("div", `wrapper--${id}--${type}`)
        const input = htmlBuilder.elementBuilder("input", `field--${id}--${type}--${key}`);
        input.setAttribute("type", `${type}`);
        if (type === "text") {
            input.setAttribute("placeholder", `add ${key}`);
            if (value){
                input.value = value;
            }
        }
        div.appendChild(label);
        div.appendChild(input);
        elementsArray.push(input);
        return div;
    },
    buildButton: function (id, name) {
        const button = htmlBuilder.elementBuilder("button", `button--${id}--${name}`, name);
        elementsArray.push(button);
        return button;
    },
    clearVariables: function () {
        wrapperType = ""
        title = ""
        keysArray = []
        valuesArray = []
        typesArray = []
        id = ""
        arrayOptionsArray = []
    },
    setWrapper: function (string) {
        wrapperType = string;
    },
    setTitle: function (string) {
        title = string;
    },
    addKey: function (string) {
        keysArray.push(string);
    },
    addValue: function (string) {
        valuesArray.push(string)
    },
    addType: function (string) {
        typesArray.push(string);
    },
    setId: function (num) {
        id = num;
    },
    addOptions: function (array) {
        arrayOptionsArray.push(array);
    },
    createForm: function() {
        const formArray = this.buildForm(wrapperType, title, keysArray, valuesArray, typesArray, id, arrayOptionsArray);
        return formArray;
    }
}
' >> formBuilder.js
  echo 'export default {
    // Function to build any elements needed.
    elementBuilder: (elementType, elementId, elementTextContent, elementValue) => {
        let htmlElement = document.createElement(elementType);
        if (elementId) {
            htmlElement.setAttribute("id", elementId);
        }

        if (elementValue) {
            htmlElement.setAttribute("value", elementValue);
        }
        htmlElement.textContent = elementTextContent;
        return htmlElement;
    }
}' >> HTMLBuilder.js
  echo '//global DOM manager.

//reference to the HTML element all elements will be posted to.
const container = document.getElementById("display-container");

export default {
    //posts HTML to the DOM.
    postToDom: item => {
        container.appendChild(item);
    },
    // Function to clear the selected element of all children.
    clearElement: domElement => {
        while (domElement.firstChild) {
            domElement.removeChild(domElement.firstChild);
        }
    },
    //removes specific element.
    removeElement: domElement => {
        domElement.parentNode.removeChild(domElement);
    }

}' >> domManager.js
  echo 'const apiURL = "http://localhost:3000"
export default {

    getAll: (key) => {
        //.then chain will wait on the return
        //builds url location with the API url / the name of the data set.
        return fetch(`${apiURL}/${key}`)
        //parse response
            .then(response => response.json())
    },

    //access a single item inside a dataset.
    getOne: (key, id) => {
        //builds URL based on APIURL, name of data set and the id of the item requested.
        return fetch(`${apiURL}/${key}/${id}`)
        //parse response.
            .then(response => response.json())
    },

    //adds a new item (object) to a specified data set (key)
    post: (key, object) => {
        return fetch(`${apiURL}/${key}`, {
            //method
            method: "POST",
            //required metadata
            headers: {
                "content-type": "application/json"
            },
            //turns the javascript object into a string that can be read in JSON.
            body: JSON.stringify(object)
        })
    },

    //removes specified item (id) from dataset (key)
    delete: (key, id) => {
        return fetch(`${apiURL}/${key}/${id}`, {
            //method
            method: "DELETE",
        })
    },

    //accesses specified data set (key), and update the specified item (id) with the values of the passed object.
    patch: (key, id, object) => {
        return fetch(`${apiURL}/${key}/${id}`, {
            //method
            method: "PATCH",
            //required metadata.
            headers: {
                "Content-type": "application/json"
            },
            body: JSON.stringify(object)
        })
    }
}
' >> apiManager.js
cd ..
  mkdir -p lib/grunt
  echo 'module.exports = function (grunt) {
    require("load-grunt-config")(grunt);
  };' >> lib/Gruntfile.js
  echo '{
  "name": "nss-modular-application",
  "version": "1.0.0",
  "description": "",
  "main": "Gruntfile.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "cross-env NODE_PATH=./node_modules grunt"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "@babel/core": "^7.1.2",
    "@babel/preset-env": "^7.1.0",
    "babelify": "^10.0.0",
    "browserify": "^16.2.3",
    "grunt": "^1.0.3",
    "grunt-browserify": "^5.3.0",
    "grunt-contrib-watch": "^1.1.0",
    "grunt-eslint": "^21.0.0",
    "grunt-http-server": "^2.1.0",
    "load-grunt-config": "^0.19.2",
    "nss-domcomponent": "^0.1.0",
    "grunt-bg-shell": "^2.3.3"
  }
}' >> lib/package.json
  echo 'default:
  - "eslint"
  - "http-server"
  - "bgShell:launchAPI"
  - "browserify"
  - "watch"
  ' >> lib/grunt/aliases.yaml
  echo 'module.exports = {
    src: ["../scripts/**/*.js", "!node_modules/**/*.js"]
}' >> lib/grunt/eslint.js
  echo 'module.exports = {
  "dev": {

      // the server root directory
      root: "../../public",

      // the server port
      // can also be written as a function, e.g.
      // port: function() { return 8282; }
      port: 8080,

      // the host ip address
      // If specified to, for example, "127.0.0.1" the server will
      // only be available on that ip.
      // Specify "0.0.0.0" to be available everywhere
      host: "0.0.0.0",

      showDir : false,
      autoIndex: true,

      // server default file extension
      ext: "html",

      // run in parallel with other tasks
      runInBackground: true,

      // Change to true for grunt task to open the
      // browser automatically
      openBrowser : false
  }
  };' >> lib/grunt/http-server.js
echo 'module.exports = {
    options: {
        transform: [
            [
                "babelify",
                {
                    "presets": [
                        [
                            "@babel/preset-env", {
                                "targets": {
                                    "node": "current"
                                }
                            }
                        ]
                    ]
                }
            ]
        ],
        browserifyOptions: {
            debug: true
        }
    },
    app: {
        src: ["../scripts/main.js"],
        dest: "../../public/bundle.js"
    }
}' >> lib/grunt/browserify.js
  echo 'module.exports = {
  launchAPI: {
      cmd: "json-server -p 8088 -w ../../api/database.json"
  },
  _defaults: {
      bg: true
  }
};
' >> lib/grunt/bgShell.js
  echo 'module.exports = {
    scripts: {
        files: [
            "../scripts/**/*.js",
            "!node_modules/**/*.js"
        ],
        tasks: ["eslint", "browserify"],
        options: {
            spawn: false,
            debounceDelay: 1000
        }
    }
}' >> lib/grunt/watch.js
  cd ..
}