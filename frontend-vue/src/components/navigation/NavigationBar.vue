<template>
    <div>
        <!-- https://bootstrap-vue.js.org/docs/components/navbar/ -->
        <b-navbar toggleable="md" type="dark" variant="info">
            <b-navbar-brand to="/">Document Analyzer</b-navbar-brand>

            <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
            <b-collapse id="nav-collapse" is-nav>
                <b-navbar-nav  class="ml-auto">
                    <b-nav-item-dropdown v-if="isAuthenticated" text="Resource" right>
                        <b-dropdown-item to="/resource/pipelines/">Pipelines</b-dropdown-item>
                        <b-dropdown-item to="/resource/operations/">Operations</b-dropdown-item>
                    </b-nav-item-dropdown>

                    <b-nav-item-dropdown v-if="isAuthenticated" right>
                        <template slot="button-content"><em>User <span v-if="isProfileLoaded">({{name}})</span></em></template>
                        <b-dropdown-item v-if="isProfileLoaded" to="/profile">
                            Profile
                        </b-dropdown-item>
                        <b-dropdown-item v-if="isAuthenticated" @click="logout">
                            <span class="logout">Logout</span>
                        </b-dropdown-item>

                    </b-nav-item-dropdown>
                    <b-nav-item v-if="!isAuthenticated && !authLoading" to="/login">
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
            ...mapActions(['authLogout']),

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
    }
</script>
