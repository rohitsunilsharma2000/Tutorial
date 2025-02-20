Below is a beginner-friendly documentation that explains step by step how to add validation to form fields in a React component. This guide uses our example component, **DoctorRegistrationForm**, which validates time fields, date fields, and a multi-select days field.

---

## Introduction

In many web forms, you need to ensure that users fill out all required fields before submitting the form. In this guide, we will add validation to our form by:

- Tracking input values and error messages using React state.
- Validating each field when the user submits the form.
- Displaying error messages next to the relevant fields.
- Automatically focusing on the first field with an error.

---

## Step-by-Step Guide

### 1. Setting Up State

We use the `useState` hook to store both the form data and any validation errors. For example, our state might look like this:

```jsx
const [formData, setFormData] = useState({
  startTime: '07:00',
  endTime: '08:00',
  days: [],
  dates: ['', ''], // Index 0: startDate, Index 1: endDate
});

const [errors, setErrors] = useState({});
```

- **formData:** Stores user input.
- **errors:** Stores error messages for each field (if any).

### 2. Handling Input Changes

We create a `handleChange` function that updates our form data. When a user fixes a field, we clear the error for that field.

```jsx
const handleChange = (e) => {
  const { name, value, type, checked, dataset } = e.target;
  
  // For date fields that share the same name, use the data-index attribute
  if (name === "dates" && dataset.index !== undefined) {
    const index = Number(dataset.index);
    setFormData((prevState) => {
      const newDates = [...prevState.dates];
      newDates[index] = value;
      return { ...prevState, dates: newDates };
    });
    const errorKey = index === 0 ? 'startDate' : 'endDate';
    if (errors[errorKey]) {
      setErrors((prevErrors) => ({ ...prevErrors, [errorKey]: null }));
    }
  } else {
    setFormData((prevState) => ({
      ...prevState,
      [name]: type === "checkbox" ? checked : value,
    }));
    if (errors[name]) {
      setErrors((prevErrors) => ({ ...prevErrors, [name]: null }));
    }
  }
};
```

### 3. Validating on Form Submission

When the form is submitted, the `handleSubmit` function performs validation:

- Check each field to ensure it is filled in.
- Update the `errors` state with appropriate messages.
- Dynamically focus on the first field with an error.

```jsx
const handleSubmit = (e) => {
  e.preventDefault();
  let valid = true;
  const newErrors = {};

  if (!formData.startTime) {
    newErrors.startTime = "Start Time is required";
    valid = false;
  }

  if (!formData.endTime) {
    newErrors.endTime = "End Time is required";
    valid = false;
  }

  if (!formData.days || formData.days.length === 0) {
    newErrors.days = "Please select at least one day";
    valid = false;
  }

  if (!formData.dates[0]) {
    newErrors.startDate = "Start Date is required";
    valid = false;
  }

  if (!formData.dates[1]) {
    newErrors.endDate = "End Date is required";
    valid = false;
  }

  if (!valid) {
    setErrors(newErrors);
    // Dynamically focus on the first field with an error
    const firstErrorField = Object.keys(newErrors)[0];
    if (firstErrorField) {
      document.getElementById(firstErrorField)?.focus();
    }
    return;
  }

  console.log("Form submitted with data:", formData);
  // Further processing (e.g., sending data to an API) goes here
};
```

### 4. Displaying Error Messages in a Flex Layout

We use Bootstrap’s flex utility classes to display the label and error message in one line. The code below shows how to adjust the layout for each field. Notice the use of `justify-content-start` to align items to the start and `ms-2` to add some margin between the label and the error message.

```jsx
<div className="d-flex align-items-center justify-content-start">
  <label htmlFor="endTime" className="form-label">End Time</label>
  {errors.endTime && (
    <div className="text-danger ms-2">{errors.endTime}</div>
  )}
</div>
<input
  type="time"
  className="form-control"
  id="endTime"
  name="endTime"
  value={formData.endTime}
  onChange={handleChange}
/>
```

### 5. Complete Example Component

Below is the complete code of our **DoctorRegistrationForm** component incorporating all of the above steps:

```jsx
"use client"
import React, { useState } from 'react';
import MultiSelectSearch from '../../../../utils/MultiSelectSearch';

const DoctorRegistrationForm = () => {
  const [formData, setFormData] = useState({
    startTime: '07:00',
    endTime: '08:00',
    days: [],
    dates: ['', ''], // Index 0: startDate, Index 1: endDate
  });
  
  const [errors, setErrors] = useState({});

  const handleChange = (e) => {
    const { name, value, type, checked, dataset } = e.target;
    
    if (name === "dates" && dataset.index !== undefined) {
      const index = Number(dataset.index);
      setFormData((prevState) => {
        const newDates = [...prevState.dates];
        newDates[index] = value;
        return { ...prevState, dates: newDates };
      });
      const errorKey = index === 0 ? 'startDate' : 'endDate';
      if (errors[errorKey]) {
        setErrors((prevErrors) => ({ ...prevErrors, [errorKey]: null }));
      }
    } else {
      setFormData((prevState) => ({
        ...prevState,
        [name]: type === "checkbox" ? checked : value,
      }));
      if (errors[name]) {
        setErrors((prevErrors) => ({ ...prevErrors, [name]: null }));
      }
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    let valid = true;
    const newErrors = {};

    if (!formData.startTime) {
      newErrors.startTime = "Start Time is required";
      valid = false;
    }

    if (!formData.endTime) {
      newErrors.endTime = "End Time is required";
      valid = false;
    }

    if (!formData.days || formData.days.length === 0) {
      newErrors.days = "Please select at least one day";
      valid = false;
    }

    if (!formData.dates[0]) {
      newErrors.startDate = "Start Date is required";
      valid = false;
    }

    if (!formData.dates[1]) {
      newErrors.endDate = "End Date is required";
      valid = false;
    }

    if (!valid) {
      setErrors(newErrors);
      // Dynamically focus on the first field with an error
      const firstErrorField = Object.keys(newErrors)[0];
      if (firstErrorField) {
        document.getElementById(firstErrorField)?.focus();
      }
      return;
    }

    console.log("Form submitted with data:", formData);
    // Further processing (e.g., API call) goes here
  };

  const clearSelection = (name) => {
    setFormData((prevState) => ({
      ...prevState,
      [name]: [],
    }));
  };

  const daysOfWeek = [
    { id: 1, value: "Monday", label: "Monday" },
    { id: 2, value: "Tuesday", label: "Tuesday" },
    { id: 3, value: "Wednesday", label: "Wednesday" },
    { id: 4, value: "Thursday", label: "Thursday" },
    { id: 5, value: "Friday", label: "Friday" },
    { id: 6, value: "Saturday", label: "Saturday" },
    { id: 7, value: "Sunday", label: "Sunday" },
    { id: 8, value: "All", label: "All" }
  ];

  return (
    <section className="section">
      <div className="row">
        <div className="col-lg-12">
          <div className="card p-4">
            <form onSubmit={handleSubmit}>
              {/* Time Section */}
              <div className="row mb-3">
                <div className="col-md-6">
                  <div className="d-flex align-items-center justify-content-start">
                    <label htmlFor="startTime" className="form-label">Start Time</label>
                    {errors.startTime && (
                      <div className="text-danger ms-2">{errors.startTime}</div>
                    )}
                  </div>
                  <input
                    type="time"
                    className="form-control"
                    id="startTime"
                    name="startTime"
                    value={formData.startTime}
                    onChange={handleChange}
                  />
                </div>
                <div className="col-md-6">
                  <div className="d-flex align-items-center justify-content-start">
                    <label htmlFor="endTime" className="form-label">End Time</label>
                    {errors.endTime && (
                      <div className="text-danger ms-2">{errors.endTime}</div>
                    )}
                  </div>
                  <input
                    type="time"
                    className="form-control"
                    id="endTime"
                    name="endTime"
                    value={formData.endTime}
                    onChange={handleChange}
                  />
                </div>
              </div>

              {/* Days Multi-select */}
              <div className="mb-3">
                <div className="d-flex align-items-center justify-content-start">
                  <label htmlFor="days" className="form-label">Days</label>
                  {errors.days && (
                    <div className="text-danger ms-2">{errors.days}</div>
                  )}
                </div>
                <MultiSelectSearch 
                  id="days"
                  options={daysOfWeek} 
                  name="days" 
                  formData={formData} 
                  handleChange={handleChange} 
                  clearSelection={clearSelection}
                />
              </div>

              {/* Dates Section */}
              <div className="row mb-3">
                <div className="col-md-6">
                  <div className="d-flex align-items-center justify-content-start">
                    <label htmlFor="startDate" className="form-label">Start Date</label>
                    {errors.startDate && (
                      <div className="text-danger ms-2">{errors.startDate}</div>
                    )}
                  </div>
                  <input
                    type="date"
                    className="form-control"
                    id="startDate"
                    name="dates"
                    data-index="0"
                    value={formData.dates[0]}
                    onChange={handleChange}
                  />
                </div>
                <div className="col-md-6">
                  <div className="d-flex align-items-center justify-content-start">
                    <label htmlFor="endDate" className="form-label">End Date</label>
                    {errors.endDate && (
                      <div className="text-danger ms-2">{errors.endDate}</div>
                    )}
                  </div>
                  <input
                    type="date"
                    className="form-control"
                    id="endDate"
                    name="dates"
                    data-index="1"
                    value={formData.dates[1]}
                    onChange={handleChange}
                  />
                </div>
              </div>

              <button type="submit" className="btn btn-primary">
                Register
              </button>
            </form>
          </div>
        </div>
      </div>
    </section>
  );
};

export default DoctorRegistrationForm;
```

---

## Summary

1. **State Management:**  
   - We use separate states for form data and errors.
2. **Input Handling:**  
   - The `handleChange` function updates state and clears errors as soon as the user modifies the input.
3. **Validation on Submit:**  
   - In `handleSubmit`, we check each field, update errors, and focus on the first error.
4. **Displaying Errors:**  
   - Errors are displayed inline next to labels using a flex container for a clean one-line layout.

This step-by-step documentation should help beginners understand how to add field validation to a React form in a structured and maintainable way.
