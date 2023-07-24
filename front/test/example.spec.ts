import { mount } from "@vue/test-utils";
import TodoList from "@/components/TodoList.vue";

describe("TodoList.vue", () => {
  it("renders a todo item", () => {
    const wrapper = mount(TodoList);
    expect(wrapper.text()).toContain("todo item");
  });
});
