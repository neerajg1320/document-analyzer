<template>
    <div>
        <!-- https://bootstrap-vue.js.org/docs/components/navbar/ -->
        <b-navbar toggleable="md" type="dark" variant="info">
            <b-navbar-brand to="/">Data Mining & Analysis</b-navbar-brand>

            <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
            <b-collapse id="nav-collapse" is-nav>

                <b-navbar-nav v-if="isAuthenticated" class="ml-auto">
                    <b-nav-item-dropdown text="PipelineStudio" right>
                        <b-dropdown-item to="/pipeline/extractor/">Extractor</b-dropdown-item>
                        <b-dropdown-item to="/pipeline/transformer">Transformer</b-dropdown-item>
                        <b-dropdown-item to="/pipeline/loader">Loader</b-dropdown-item>
                    </b-nav-item-dropdown>

                    <b-nav-item-dropdown text="ResourceDashboard" right>
                        <b-dropdown-item to="/resource/files/">Files</b-dropdown-item>
                        <b-dropdown-item to="/resource/documents/">Documents</b-dropdown-item>
                        <b-dropdown-item to="/resource/schemas/">Schemas</b-dropdown-item>
                        <b-dropdown-item to="/resource/datastores/">Datastores</b-dropdown-item>
                        <b-dropdown-item to="/resource/datastoretypes/">DatastoreTypes</b-dropdown-item>
                        <b-dropdown-item to="/resource/operations/">Operations</b-dropdown-item>
                        <b-dropdown-item to="/resource/pipelines/">Pipelines</b-dropdown-item>
                    </b-nav-item-dropdown>

                    <b-nav-item-dropdown right>
                        <template slot="button-content"><em>User <span v-if="isProfileLoaded">({{name}})</span></em></template>
                        <b-dropdown-item v-if="isProfileLoaded" to="/profile">
                            Profile
                        </b-dropdown-item>
                        <b-dropdown-item @click="logout">
                            <span class="logout">Logout</span>
                        </b-dropdown-item>

                    </b-nav-item-dropdown>
                </b-navbar-nav>

                <b-navbar-nav v-else class="ml-auto">
                    <b-nav-item v-if="!authLoading" to="/login">
                        Login
                    </b-nav-item>
                </b-navbar-nav>
            </b-collapse>
        </b-navbar>
    </div>
</template>

<style lang="scss" scoped>
    a {
        color: white;
        text-decoration: none;
    }
    .navigation {
        display: flex;
        color: white;
        align-items: center;
        background-color: #ffa035;
        padding: 5px;

        ul{
            display: flex;
            &:first-child{
                flex-grow: 1;
            }
            li {
                padding-right: 1em;
            }
        }
    }
    .brand {
        display: flex;
        align-items: center;

    }
    .logout {
        &:hover {
            cursor: pointer;
        }
    }

</style>

<script>
    import { mapActions, mapGetters, mapState } from 'vuex'
    // import { AUTH_LOGOUT } from '../../store/actions/auth'

    export default {
        name: 'navigation',
        methods: {
            ...mapActions(['authLogout', 'userRequest']),

            logout: function () {
                this.authLogout()
                    .then(() => this.$router.push('/login'))
            }
        },
        computed: {
            ...mapGetters(['getProfile', 'isAuthenticated', 'isProfileLoaded']),
            ...mapState({
                authLoading: state => state.auth.status === 'loading',
                name: state => `${state.user.profile.name}`,
            })
        },

        created() {
          if (this.isAuthenticated) {
            this.userRequest();
          }
        }
    }
</script>
