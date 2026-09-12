/**
 * Safe localStorage wrappers — Storage can throw in private/incognito mode
 * or when blocked by browser policy even when the API appears present.
 */

export const storageGet = (key) => {
	try {
		return localStorage.getItem(key);
	} catch {
		return null;
	}
};

export const storageSet = (key, value) => {
	try {
		localStorage.setItem(key, value);
	} catch {
		// Storage unavailable
	}
};

export const storageRemove = (key) => {
	try {
		localStorage.removeItem(key);
	} catch {
		// Storage unavailable
	}
};
