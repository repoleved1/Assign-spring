package com.example.spring06.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.persistence.Transient;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Controller
public class UploadController {
    @Transient
    private UUID uuidImg = UUID.randomUUID();
    private static String UPLOADED_FOLDER = "target/classes/static/uploaded/";

    @GetMapping("/upload")
    public String index() {
        return "upload";
    }

    @PostMapping("/upload")
    public String uploadImg(@RequestParam("img") MultipartFile file, RedirectAttributes redirectAttributes) {
        if(file.isEmpty()) {
            redirectAttributes.addFlashAttribute("msg", "Please check your image upload");
            return "redirect:/upload";
        }
        try {
            byte[] bytes = file.getBytes();
            UUID uuid = UUID.randomUUID();
            Path path = Paths.get(UPLOADED_FOLDER + uuid + '-' + file.getOriginalFilename());
            Files.write(path, bytes);
            redirectAttributes.addFlashAttribute("msg", "Uploaded image success!");
            redirectAttributes.addFlashAttribute("img_name", file.getOriginalFilename());
            redirectAttributes.addFlashAttribute("img_url", "/uploaded/" + uuid  + '-' + file.getOriginalFilename());
            redirectAttributes.addFlashAttribute("url", path);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "redirect:/upload";
    }
}
