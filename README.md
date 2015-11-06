paper-search [![Bower version](https://badge.fury.io/bo/paper-search.svg)](http://badge.fury.io/bo/paper-search)
=========

`paper-search` provides a Material Design [search](https://www.google.com/design/spec/patterns/search.html). The web component is built with [Polymer 1.x](https://www.polymer-project.org).

![Screenshot](/doc/screenshot.png "Screenshot")


## Usage

`bower install paper-search`

```html
<paper-search
  placeholder="Enter search term"
  nr-selected-filters="3"
  on-paper-search-search="search"
  on-paper-search-filter="filter"
></paper-search>
```


## Properties

These properties are available for `paper-search`:

Property              | Type   | Description
--------------------- | ------ | ----------------------------
**query**             | String | Search query entered by the user
**nrSelectedFilters** | Number | Number of selected filters (shown in the badge)
**placeholder**       | String | Text shown in the search box if the user didn't enter any query


## License

    This software is licensed under the Apache 2 license, quoted below.

    Copyright 2011-2015 Collaborne B.V. <http://github.com/Collaborne/>

    Licensed under the Apache License, Version 2.0 (the "License"); you may not
    use this file except in compliance with the License. You may obtain a copy of
    the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
    License for the specific language governing permissions and limitations under
    the License.
    