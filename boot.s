/*_____________________________________________________________________________________________
Copyright 2011 Nishchay Mhatre

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
_____________________________________________________________________________________________ */ 
.text
.code 32
.global _entry
.func _entry

_entry:
	LDR 	SP, =__c_stack_top__
	BL 	main

.size _entry, . - _entry 
.endfunc
.end
