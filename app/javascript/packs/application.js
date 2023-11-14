// app/javascript/packs/application.js

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import toastr from 'toastr';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import "./tag_select";
import "./chat";
import "./profile";
import "./user_count";
import "./user_list";
import "./form_validation";
import "./toastr";
import "./block_users"
import "./notification"