import { defineStore } from "pinia";
import axios from "axios";

export const useAppStore = defineStore("app", {
  state: () => ({
    user: null,
    isLoggedIn: false,
    message: "",
  }),
  actions: {
    async login(email, password) {
      try {
        const response = await axios.post(
          "http://localhost:3000/api/auth/login",
          { email, password },
        );
        this.user = response.data.user;
        this.isLoggedIn = true;
        localStorage.setItem("token", response.data.token);
        this.message = "Login successful!";
        return true;
      } catch (error) {
        if (error.response?.status === 403) {
          throw error; 
        }
        this.message =
          error.response?.data?.message || "Error connecting to server";
        return false;
      }
    },
    logout() {
      this.user = null;
      this.isLoggedIn = false;
      this.message = "";
    },
  },
  persist: {
    paths: ["user", "isLoggedIn"],
  },
});
