Vue.component('tab', {
    template: `
    <div v-show="isActive"><slot></slot></div>
    `,
    props: {
        name: {required: true},
        selected: {default: false}
    },

    data() {
        return {
            isActive: false
        };
    },
    computed: {
        href() {
            return '#' + this.name.toLowerCase().replace(/ /g, '-');
        }
    },
    mounted() {
        this.isActive = this.selected;
    }
});

Vue.component('tabs', {
    template: `
    <div>
        <div class="tabs">
          <ul>
            <li v-for="tab in tabs" :class="{ 'is-active':tab.isActive }">
                <a :href="tab.href" @click="selectTab(tab)">{{tab.name}}</a>
            </li>
          </ul>
        </div>
        <div class="tabs-details">
            <slot></slot>
        </div>
    </div>
    `,
    mounted() {
        console.log(this.$children);
    },
    created() {
        this.tabs = this.$children;
    },
    data() {
        return { tabs: []};
    },
    methods: {
        selectTab(selectedTab) {
            this.tabs.forEach(tab => {
                tab.isActive = (tab.name == selectedTab.name);
            })
        }
    }
});

Vue.component('modal', {
    template: `
        <div class="modal is-active">
            <div class="modal-background"></div>
            <div class="modal-content">
                <div class="box">
                    <slot></slot>
                </div>
            </div>
            <button class="modal-close is-large" aria-label="close" @click="$emit('close')"></button>
        </div>
    `,
});

Vue.component('message', {
    props: ['title', 'body'],
    data() {
        return {
            isVisible: true
        };
    },
    template: `
       <article class="message" v-show="isVisible">
        <div class="message-header">
            {{ title }}
            <button class="delete" @click="hideModel"></button>
            
        </div>
        <div class="message-body">
            {{ body }}
        </div>
    </article>
    `,
    methods: {
        hideModel() {
            this.isVisible = false;
        }
    }
});


// We will be able to use <task> html tag in our html file
Vue.component('task-list', {

    template: '<ul><task v-for="task in tasks">{{ task.description}}</task></ul>',

    data() {
        return {
            tasks: [
                {description: "Go to the store", completed: true},
                {description: "Finish screencast", completed: false},
                {description: "Make donation", completed: false},
                {description: "Clear inbox", completed: false},
                {description: "Make dinner", completed: false},
                {description: "Clean room", completed: true}
            ]
        };
    }
});


Vue.component('task', {

    template: '<li><slot></slot></li>'
});



new Vue({
    el: '#root',
    data: {
        showModal: false
    }
});
